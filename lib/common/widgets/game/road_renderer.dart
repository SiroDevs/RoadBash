// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'dash_layout.dart';
import 'road_backdrop.dart';
import 'road_config.dart';
import 'road_decor_painter.dart';
import 'road_projection.dart';
import 'road_segment_painter.dart';
import 'road_theme.dart';
import 'road_track.dart';

/// Pseudo-3D road. Pass 1 projects segments near-to-far (with a "highest
/// line so far" clip for hills) and paints the road itself. Pass 2 paints
/// roadside scenery far-to-near so nearer objects cover farther ones.
class RoadRenderer extends PositionComponent {
  RoadRenderer(this.theme)
      : track = RoadTrack(theme.id),
        _backdrop = RoadBackdrop(theme),
        _roads = RoadSegmentPainter(theme),
        _decor = RoadDecorPainter(theme);

  final SceneTheme theme;
  final RoadTrack track;
  final RoadBackdrop _backdrop;
  final RoadSegmentPainter _roads;
  final RoadDecorPainter _decor;

  // ---- Rider state (written by RoadGame, read by rider / HUD / audio) ------
  double trkPosition = 0; // position on the looping track
  double fullDistance = 0; // total distance ridden (never wraps)
  double playerX = 0.25; // -1 .. +1 is on the tarmac
  double speed = 0;
  double steer = 0; // -1 left, 0 straight, +1 right
  bool throttle = true;
  bool brake = false;
  bool locked = true; // true on the grid, before "GO!"
  bool skidding = false;
  double rpm = 0.16; // 0..1
  int gear = 1;
  double playerZ = RoadConfig.cameraHeight * RoadConfig.cameraDepth;

  double get speedPercent => speed / RoadConfig.maxSpeed;
  double get speedKmh => speedPercent * RoadConfig.topSpeedKmh;
  bool get offRoad => playerX < -1 || playerX > 1;
  double get engineLoad => brake ? 0.3 : (throttle ? 1.0 : 0.5);

  final List<VisSeg> _vis =
      List.generate(RoadConfig.drawDistance, (_) => VisSeg());
  int _visCount = 0;
  final _p1 = ProjPoint();
  final _p2 = ProjPoint();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _backdrop.resize(size);
    playerZ = DashLayout.playerZ(size);
  }

  // ---- Simulation ---------------------------------------------------------
  @override
  void update(double dt) {
    final seg = track.at(trkPosition + playerZ);
    if (locked) {
      speed = 0;
      skidding = false;
      rpm += ((throttle ? 0.30 : 0.16) - rpm) * math.min(1.0, dt * 8);
      return;
    }
    final sp = speedPercent;
    final step = dt * speed;
    trkPosition = (trkPosition + step) % track.length;
    fullDistance += step;

    final dx = dt * 2 * sp;
    playerX += dx * steer;
    playerX -= dx * sp * seg.curve * RoadConfig.centrifugal;

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
    playerX = math.max(-2.0, math.min(2.0, playerX));
    speed = math.max(0.0, math.min(RoadConfig.maxSpeed, speed));

    skidding = speed > RoadConfig.maxSpeed * 0.3 &&
        (brake || (steer.abs() > 0.4 && sp > 0.8 && seg.curve.abs() > 2.5));
    _updateEngine(dt, sp);
    _backdrop.scroll += seg.curve * sp * dt * 40;
  }

  /// Six-speed gearbox: rpm climbs inside a gear, then drops on the shift.
  void _updateEngine(double dt, double sp) {
    const gears = 6;
    gear = math.min(gears, 1 + (sp * gears).floor());
    final inGear = math.min(1.0, math.max(0.0, sp * gears - (gear - 1)));
    final target = 0.28 + 0.72 * inGear;
    rpm += (target - rpm) * math.min(1.0, dt * 10);
  }

  // ---- Rendering ----------------------------------------------------------
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

    for (var n = 0; n < RoadConfig.drawDistance; n++) {
      final seg = track.segments[(baseIdx + n) % track.count];
      final looped = seg.index < baseIdx;
      final camX = playerX * RoadConfig.roadWidth - x;
      final camY = playerY + RoadConfig.cameraHeight;
      final camZ = trkPosition - (looped ? track.length : 0);

      _project(_p1, seg.y1, seg.index * len, camX, camY, camZ);
      _project(_p2, seg.y2, (seg.index + 1) * len, camX - dx, camY, camZ);
      x += dx;
      dx += seg.curve;

      if (_p1.z <= RoadConfig.cameraDepth ||
          _p2.y >= _p1.y ||
          _p2.y >= maxY) {
        continue;
      }
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
      _roads.draw(canvas, v, size.x);
      maxY = _p2.y;
    }

    for (var i = _visCount - 1; i >= 0; i--) {
      final v = _vis[i];
      if (v.n < RoadConfig.decorDistance) _decor.draw(canvas, v, size.x);
    }
  }
}
