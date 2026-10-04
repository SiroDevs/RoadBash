// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'road_backdrop.dart';
import 'road_config.dart';
import 'road_track.dart';

/// Reusable projected point (avoids allocating every frame).
class _Pt {
  double x = 0, y = 0, w = 0, z = 0;
}

/// Pseudo-3D road: the track is projected from a camera behind the rider.
/// Segments are drawn near-to-far with a "highest line so far" clip, which
/// gives correct hills and occlusion.
class RoadRenderer extends PositionComponent {
  double trkPosition = 0; // distance along the track
  double playerX = 0; // -1 .. +1 is on the tarmac
  double speed = 0;
  double steer = 0; // -1 left, 0 straight, +1 right
  bool throttle = true;
  bool brake = false;

  double get speedPercent => speed / RoadConfig.maxSpeed;
  bool get offRoad => playerX < -1 || playerX > 1;

  final RoadTrack track = RoadTrack();
  final RoadBackdrop _backdrop = RoadBackdrop();

  static Paint _paint(Color c) => Paint()
    ..color = c
    ..isAntiAlias = false;

  final _grassLight = _paint(const Color(0xFF2E9E3A));
  final _grassDark = _paint(const Color(0xFF278F33));
  final _rumbleLight = _paint(const Color(0xFFE53935));
  final _rumbleDark = _paint(const Color(0xFFF2F2F2));
  final _roadLight = _paint(const Color(0xFF6E6E73));
  final _roadDark = _paint(const Color(0xFF68686D));
  final _lanePaint = _paint(const Color(0xFFE8E8E8));

  final _path = Path();
  final _p1 = _Pt();
  final _p2 = _Pt();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _backdrop.resize(size);
  }

  // Simulation
  @override
  void update(double dt) {
    final seg = track.at(trkPosition + RoadConfig.playerZ);
    final sp = speedPercent;

    trkPosition = (trkPosition + dt * speed) % track.length;

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

    _backdrop.scroll += seg.curve * sp * dt * 40;
  }

  // Rendering
  void _project(_Pt p, double wy, double wz, double camX, double camY,
      double camZ) {
    final cz = wz - camZ;
    p.z = cz;
    final scale = RoadConfig.cameraDepth / cz;
    p.x = size.x / 2 + scale * (0 - camX) * size.x / 2;
    p.y = size.y * RoadConfig.horizonRatio - scale * (wy - camY) * size.y / 2;
    p.w = scale * RoadConfig.roadWidth * size.x / 2;
  }

  void _poly(Canvas c, double x1, double y1, double x2, double y2, double x3,
      double y3, double x4, double y4, Paint paint) {
    _path
      ..reset()
      ..moveTo(x1, y1)
      ..lineTo(x2, y2)
      ..lineTo(x3, y3)
      ..lineTo(x4, y4)
      ..close();
    c.drawPath(_path, paint);
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0 || size.y <= 0) return;
    _backdrop.draw(canvas, size);

    final baseIdx = track.indexAt(trkPosition);
    final base = track.segments[baseIdx];
    final basePercent =
        (trkPosition % RoadConfig.segmentLength) / RoadConfig.segmentLength;

    final pz = trkPosition + RoadConfig.playerZ;
    final pSeg = track.at(pz);
    final pPercent = (pz % RoadConfig.segmentLength) / RoadConfig.segmentLength;
    final playerY = pSeg.y1 + (pSeg.y2 - pSeg.y1) * pPercent;

    var x = 0.0;
    var dx = -(base.curve * basePercent);
    var maxY = size.y;

    for (var n = 0; n < RoadConfig.drawDistance; n++) {
      final seg = track.segments[(baseIdx + n) % track.count];
      final looped = seg.index < baseIdx;

      final camX = playerX * RoadConfig.roadWidth - x;
      final camY = playerY + RoadConfig.cameraHeight;
      final camZ = trkPosition - (looped ? track.length : 0);
      final len = RoadConfig.segmentLength;

      _project(_p1, seg.y1, seg.index * len, camX, camY, camZ);
      _project(_p2, seg.y2, (seg.index + 1) * len, camX - dx, camY, camZ);

      x += dx;
      dx += seg.curve;

      if (_p1.z <= RoadConfig.cameraDepth ||
          _p2.y >= _p1.y ||
          _p2.y >= maxY) {
        continue;
      }
      _drawSegment(canvas, seg);
      maxY = _p2.y;
    }
  }

  void _drawSegment(Canvas canvas, RoadSegment seg) {
    final light = (seg.index ~/ RoadConfig.rumbleLength).isEven;
    final x1 = _p1.x, y1 = _p1.y, w1 = _p1.w;
    final x2 = _p2.x, y2 = _p2.y, w2 = _p2.w;
    const lanes = RoadConfig.lanes;

    // Grass
    canvas.drawRect(
        Rect.fromLTRB(0, y2, size.x, y1 + 1), light ? _grassLight : _grassDark);

    // Rumble strips
    final r1 = w1 / math.max(6, 2 * lanes);
    final r2 = w2 / math.max(6, 2 * lanes);
    final rumble = light ? _rumbleLight : _rumbleDark;
    _poly(canvas, x1 - w1 - r1, y1, x1 - w1, y1, x2 - w2, y2, x2 - w2 - r2, y2,
        rumble);
    _poly(canvas, x1 + w1 + r1, y1, x1 + w1, y1, x2 + w2, y2, x2 + w2 + r2, y2,
        rumble);

    // Tarmac
    _poly(canvas, x1 - w1, y1, x1 + w1, y1, x2 + w2, y2, x2 - w2, y2,
        light ? _roadLight : _roadDark);

    // Dashed lane markings (light bands only)
    if (!light) return;
    final l1 = w1 / math.max(32, 8 * lanes);
    final l2 = w2 / math.max(32, 8 * lanes);
    final lw1 = w1 * 2 / lanes;
    final lw2 = w2 * 2 / lanes;
    var lx1 = x1 - w1 + lw1;
    var lx2 = x2 - w2 + lw2;
    for (var lane = 1; lane < lanes; lane++) {
      _poly(canvas, lx1 - l1 / 2, y1, lx1 + l1 / 2, y1, lx2 + l2 / 2, y2,
          lx2 - l2 / 2, y2, _lanePaint);
      lx1 += lw1;
      lx2 += lw2;
    }
  }
}
