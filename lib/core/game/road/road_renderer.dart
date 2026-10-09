// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dash_layout.dart';
import 'road_backdrop.dart';
import 'road_config.dart';
import 'road_decor_painter.dart';
import 'road_projection.dart';
import 'road_props.dart';
import 'road_segment_painter.dart';
import 'road_theme.dart';
import 'road_track.dart';

/// Pseudo-3D road. Pass 1 projects segments near-to-far and paints the road;
/// pass 2 paints roadside scenery far-to-near so nearer objects cover farther.
class RoadRenderer extends PositionComponent {
  RoadRenderer(this.theme)
      : track = RoadTrack(theme.id),
        _backdrop = RoadBackdrop(theme),
        _roads = RoadSegmentPainter(theme),
        _decor = RoadDecorPainter(theme) {
    props = RoadProps(theme, track.count);
  }

  final SceneTheme theme;
  final RoadTrack track;
  late final RoadProps props;
  final RoadBackdrop _backdrop;
  final RoadSegmentPainter _roads;
  final RoadDecorPainter _decor;

  double trkPosition = 0;
  double fullDistance = 0;
  double playerX = 0.25;
  double speed = 0;

  /// Raw input, -1 to 1. [appliedSteer] is what the bike actually does.
  double steer = 0;
  double appliedSteer = 0;
  bool throttle = false;
  bool brake = false;
  bool locked = true;
  bool skidding = false;
  double rpm = 0.16;
  int gear = 1;
  double playerZ = RoadConfig.cameraHeight * RoadConfig.cameraDepth;

  /// Curve of the segment under the bike, smoothed. Drives the rider's lean
  /// and the backdrop drift so neither snaps at a corner entry.
  double curveFelt = 0;

  double get speedPercent => speed / RoadConfig.maxSpeed;
  double get speedKmh => speedPercent * RoadConfig.topSpeedKmh;
  bool get offRoad => playerX < -1 || playerX > 1;
  bool get stopped => speed < RoadConfig.stoppedSpeed;
  bool get restingOnFoot => stopped && !throttle;
  double get engineLoad => brake ? 0.3 : (throttle ? 1.0 : 0.5);

  final List<VisSeg> _vis =
      List.generate(RoadConfig.drawDistance, (_) => VisSeg());
  final List<VisSeg?> _byN = List.filled(RoadConfig.drawDistance, null);
  int _visCount = 0;
  int _firstN = 0;
  int _lastN = 0;
  final _p1 = ProjPoint();
  final _p2 = ProjPoint();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _backdrop.resize(size);
    playerZ = DashLayout.playerZ(size);
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

    // Steering bites less the faster you go, so the bike settles into a line
    // instead of darting a whole lane per key press.
    final authority = 1 - RoadConfig.steerHighSpeedDamp * sp;
    playerX += dt * RoadConfig.steerRate * appliedSteer * sp * authority;
    playerX -= dt * RoadConfig.centrifugal * seg.curve * sp * sp;

    if (brake) {
      speed += RoadConfig.braking * dt;
    } else if (throttle) {
      speed += RoadConfig.accel * dt;
    } else {
      speed += RoadConfig.decel * dt;
    }
    if (offRoad && speed > RoadConfig.offRoadLimit) {
      speed += RoadConfig.offRoadDecel * dt;
    }
    const edge = RoadConfig.maxOffRoad;
    playerX = math.max(-edge, math.min(edge, playerX));
    speed = math.max(0.0, math.min(RoadConfig.maxSpeed, speed));

    skidding = speed > RoadConfig.maxSpeed * 0.3 &&
        (brake ||
            (appliedSteer.abs() > 0.4 && sp > 0.8 && seg.curve.abs() > 2.5));
    _updateEngine(dt, sp);
    _backdrop.scroll += curveFelt * sp * dt * 34;
  }

  /// Ramps the bars toward the input. Falling back to centre is quicker than
  /// winding on lock, which is what stops a tap of the arrow key snapping.
  void _steerToward(double dt, double target) {
    final t = target.clamp(-1.0, 1.0).toDouble();
    final rate = t.abs() > appliedSteer.abs()
        ? RoadConfig.steerAttack
        : RoadConfig.steerRelease;
    appliedSteer += (t - appliedSteer) * math.min(1.0, dt * rate);
  }

  void _settleRpm(double dt, double target) =>
      rpm += (target - rpm) * math.min(1.0, dt * 8);

  /// Six-speed gearbox: rpm climbs inside a gear, then drops on the shift.
  void _updateEngine(double dt, double sp) {
    const gears = 6;
    gear = math.min(gears, 1 + (sp * gears).floor());
    final inGear = math.min(1.0, math.max(0.0, sp * gears - (gear - 1)));
    _settleRpm(dt * 1.25, stopped && !throttle ? 0.16 : 0.28 + 0.72 * inGear);
  }

  void _project(ProjPoint p, double wy, double wz, double camX, double camY,
      double camZ) {
    final cz = wz - camZ;
    final scale = RoadConfig.cameraDepth / cz;
    p.z = cz;
    p.x = size.x / 2 + scale * (0 - camX) * size.x / 2;
    p.y = size.y * RoadConfig.horizonRatio - scale * (wy - camY) * size.y / 2;
    p.w = scale * RoadConfig.roadWidth * size.x / 2;
    p.k = scale * size.y / 2;
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

      // Clip the near edge to RoadConfig.nearClip instead of projecting
      // points that sit almost on the camera.
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
      // Everything past here is pure haze, which the backdrop already paints.
      if (v.fog >= 1) break;
    }

    if (_visCount > 0) _drawDecor(canvas, baseIdx);
  }

  /// Walks the visible segments far-to-near and draws the props anchored on
  /// each, so nearer scenery paints over farther scenery.
  ///
  /// The scan starts behind the camera because a building you are level with
  /// is anchored on a segment you have already passed.
  void _drawDecor(Canvas canvas, int baseIdx) {
    final near = _byN[_firstN]!;
    final limit = math.min(RoadConfig.decorDistance, _lastN + 1);

    for (var n = limit - 1; n >= -RoadConfig.maxPropDepth; n--) {
      final list =
          props.at((baseIdx + n + track.count * 2) % track.count);
      if (list.isEmpty) continue;

      // Props behind the camera hang off the first segment still on screen.
      final anchor = n < _firstN ? near : _byN[n];
      if (anchor == null) continue;

      for (final prop in list) {
        if (prop.depth == 0) {
          _decor.drawBillboard(canvas, anchor, prop, size);
          continue;
        }
        final backN = math.min(n + prop.depth, _lastN);
        if (backN <= _firstN) continue; // Wholly behind the camera.
        final back = _byN[backN] ?? _findBack(backN);
        if (back == null || back == anchor) continue;
        _decor.drawBox(canvas, anchor, back, prop, size);
      }
    }
  }

  /// Nearest projected segment at or before [n], for props whose back face
  /// landed on a segment that was culled.
  VisSeg? _findBack(int n) {
    for (var i = n; i >= _firstN; i--) {
      final v = _byN[i];
      if (v != null) return v;
    }
    return null;
  }
}
