// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dashboard_layout.dart';
import 'backdrop/road_backdrop.dart';
import 'config/road_config.dart';
import 'props/painters/prop_painter.dart';
import 'projection/road_projection.dart';
import 'props/road_props.dart';
import 'surface/road_segment_painter.dart';
import 'scene/scene_theme.dart';
import 'track/road_track.dart';
import 'config/vehicle_config.dart';

class RoadRenderer extends PositionComponent {
  RoadRenderer(this.theme)
    : track = RoadTrack(theme.id),
      _backdrop = RoadBackdrop(theme),
      _roads = RoadSegmentPainter(theme),
      _decor = PropPainter(theme) {
    props = RoadProps(theme, track);
  }

  final SceneTheme theme;
  final RoadTrack track;
  late final RoadProps props;
  final RoadBackdrop _backdrop;
  final RoadSegmentPainter _roads;
  final PropPainter _decor;

  double trkPosition = 0, fullDistance = 0;
  double playerX = -0.25, speed = 0;

  double steer = 0, appliedSteer = 0, rpm = 0.16;
  bool throttle = false, brake = false;
  bool locked = true, skidding = false;
  int gear = 1;
  double playerZ = RoadConfig.cameraHeight * RoadConfig.cameraDepth;

  double curveFelt = 0;
  double _spread = 1;

  double get speedPercent => speed / VehicleConfig.maxSpeed;
  double get speedKmh => speedPercent * VehicleConfig.topSpeedKmh;
  bool get offRoad => playerX < -1 || playerX > 1;
  bool get stopped => speed < VehicleConfig.stoppedSpeed;
  bool get restingOnFoot => stopped && !throttle;
  double get engineLoad => brake ? 0.3 : (throttle ? 1.0 : 0.5);

  final List<VisionSeg> _vis = List.generate(
    RoadConfig.drawDistance,
    (_) => VisionSeg(),
  );
  final List<VisionSeg?> _byN = List.filled(RoadConfig.drawDistance, null);
  int _visCount = 0;
  int _firstN = 0;
  int _lastN = 0;
  final _p1 = ProjectionPoint();
  final _p2 = ProjectionPoint();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _backdrop.resize(size);
    playerZ = DashboardLayout.cameraDistance(size);
    _spread = DashboardLayout.roadSpread(size);
  }

  @override
  void update(double dt) {
    final seg = track.at(trkPosition + playerZ);
    _steerToward(dt, locked ? 0 : steer);
    if (locked) {
      speed = 0;
      skidding = false;
      curveFelt += (0 - curveFelt) * math.min(1.0, dt * 4);
      _settleRpm(dt, throttle ? 0.30 : 0.16);
      return;
    }
    final sp = speedPercent;
    final step = dt * speed;
    trkPosition = (trkPosition + step) % track.length;
    fullDistance += step;

    curveFelt += (seg.curve - curveFelt) * math.min(1.0, dt * 3.5);

    final authority = 1 - VehicleConfig.steerHighSpeedDamp * sp;
    playerX += dt * VehicleConfig.steerRate * appliedSteer * sp * authority;
    playerX -= dt * VehicleConfig.centrifugal * seg.curve * sp * sp;

    if (brake) {
      speed += VehicleConfig.braking * dt;
    } else if (throttle) {
      speed += VehicleConfig.accel * dt;
    } else {
      speed += VehicleConfig.decel * dt;
    }
    if (offRoad && speed > VehicleConfig.offRoadLimit) {
      speed += VehicleConfig.offRoadDecel * dt;
    }
    const edge = VehicleConfig.maxOffRoad;
    playerX = math.max(-edge, math.min(edge, playerX));
    speed = math.max(0.0, math.min(VehicleConfig.maxSpeed, speed));

    skidding =
        speed > VehicleConfig.maxSpeed * 0.3 &&
        (brake ||
            (appliedSteer.abs() > 0.4 && sp > 0.8 && seg.curve.abs() > 2.5));
    _updateEngine(dt, sp);
    _backdrop.scroll += curveFelt * sp * dt * 34;
  }

  void _steerToward(double dt, double target) {
    final t = target.clamp(-1.0, 1.0).toDouble();
    final rate = t.abs() > appliedSteer.abs()
        ? VehicleConfig.steerAttack
        : VehicleConfig.steerRelease;
    appliedSteer += (t - appliedSteer) * math.min(1.0, dt * rate);
  }

  void _settleRpm(double dt, double target) =>
      rpm += (target - rpm) * math.min(1.0, dt * 8);

  void _updateEngine(double dt, double sp) {
    const gears = 6;
    gear = math.min(gears, 1 + (sp * gears).floor());
    final inGear = math.min(1.0, math.max(0.0, sp * gears - (gear - 1)));
    _settleRpm(dt * 1.25, stopped && !throttle ? 0.16 : 0.28 + 0.72 * inGear);
  }

  void _project(
    ProjectionPoint p,
    double wy,
    double wz,
    double camX,
    double camY,
    double camZ,
  ) {
    final cz = wz - camZ;
    final scale = RoadConfig.cameraDepth / cz;
    p.z = cz;
    final unit = size.y / 2;
    p.x = size.x / 2 + scale * (0 - camX) * unit * _spread;
    p.y = size.y * RoadConfig.horizonRatio - scale * (wy - camY) * unit;
    p.w = scale * RoadConfig.roadWidth * unit * _spread;
    p.k = scale * unit;
  }

  static double _fogAt(int n) {
    const a = RoadConfig.fogStart, b = RoadConfig.fogEnd;
    final t = (n / RoadConfig.drawDistance - a) / (b - a);
    return t < 0 ? 0.0 : (t > 1 ? 1.0 : t);
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0 || size.y <= 0) return;
    _backdrop.draw(canvas, size);

    const len = RoadConfig.segmentLength;
    final baseIdx = track.indexAt(trkPosition);
    final base = track.segments[baseIdx];
    final basePercent = (trkPosition % len) / len;
    final pz = trkPosition + playerZ;
    final pSeg = track.at(pz);
    final playerY = pSeg.y1 + (pSeg.y2 - pSeg.y1) * ((pz % len) / len);

    var x = 0.0;
    var dx = -(base.curve * basePercent);
    var maxY = size.y;
    _visCount = 0;
    _firstN = -1;
    _lastN = -1;
    _byN.fillRange(0, _byN.length, null);

    for (var n = 0; n < RoadConfig.drawDistance; n++) {
      final seg = track.segments[(baseIdx + n) % track.count];
      final looped = seg.index < baseIdx;
      final camX = playerX * RoadConfig.roadWidth - x;
      final camY = playerY + RoadConfig.cameraHeight;
      final camZ = trkPosition - (looped ? track.length : 0);

      final camX2 = camX - dx;
      _project(_p1, seg.y1, seg.index * len, camX, camY, camZ);
      _project(_p2, seg.y2, (seg.index + 1) * len, camX2, camY, camZ);
      x += dx;
      dx += seg.curve;

      if (_p1.z < RoadConfig.nearClip) {
        if (_p2.z <= RoadConfig.nearClip) continue;
        final t = (RoadConfig.nearClip - _p1.z) / (_p2.z - _p1.z);
        _project(
          _p1,
          seg.y1 + (seg.y2 - seg.y1) * t,
          camZ + RoadConfig.nearClip,
          camX + (camX2 - camX) * t,
          camY,
          camZ,
        );
      }
      if (_p2.y >= _p1.y || _p2.y >= maxY) continue;

      final v = _vis[_visCount++];
      v.seg = seg;
      v.n = n;
      v.x1 = _p1.x;
      v.y1 = _p1.y;
      v.w1 = _p1.w;
      v.k1 = _p1.k;
      v.x2 = _p2.x;
      v.y2 = _p2.y;
      v.w2 = _p2.w;
      v.k2 = _p2.k;
      v.clip = maxY;
      v.fog = _fogAt(n);
      _byN[n] = v;
      if (_firstN < 0) _firstN = n;
      _lastN = n;
      _roads.draw(canvas, v, size.x);
      maxY = _p2.y;
      if (v.fog >= 1) break;
    }

    if (_visCount > 0) _drawDecor(canvas, baseIdx);
  }

  void _drawDecor(Canvas canvas, int baseIdx) {
    final near = _byN[_firstN]!;
    final limit = math.min(RoadConfig.decorDistance, _lastN + 1);

    for (var n = limit - 1; n >= -RoadConfig.maxPropDepth; n--) {
      final list = props.at((baseIdx + n + track.count * 2) % track.count);
      if (list.isEmpty) continue;

      final anchor = n < _firstN ? near : _byN[n];
      if (anchor == null) continue;

      for (final prop in list) {
        if (prop.depth == 0) {
          _decor.drawBillboard(canvas, anchor, prop, size);
          continue;
        }
        final backN = math.min(n + prop.depth, _lastN);
        if (backN <= _firstN) continue;
        final back = _byN[backN] ?? _findBack(backN);
        if (back == null || back == anchor) continue;
        _decor.drawBox(canvas, anchor, back, prop, size);
      }
    }
  }

  VisionSeg? _findBack(int n) {
    for (var i = n; i >= _firstN; i--) {
      final v = _byN[i];
      if (v != null) return v;
    }
    return null;
  }
}
