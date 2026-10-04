import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

/// One slice of track. [y1]/[y2] are the world heights at its near/far edge,
/// [curve] is how much it bends the road (+ right, - left).
class _Segment {
  _Segment(this.index, this.y1, this.y2, this.curve);
  final int index;
  final double y1;
  final double y2;
  final double curve;
}

/// Reusable projected point (avoids allocating every frame).
class _P {
  double x = 0, y = 0, w = 0, z = 0;
}

/// Pseudo-3D road: the track is a list of segments projected from a camera
/// that sits behind the rider. Far segments are drawn first-to-last with a
/// "highest line so far" clip, which gives correct hills and occlusion.
class RoadRenderer extends PositionComponent {
  RoadRenderer() {
    _buildTrack();
  }

  // ---- Tunables -----------------------------------------------------------
  static const double segmentLength = 200;
  static const double roadWidth = 1600; // world half-width = roadWidth
  static const double cameraHeight = 1000;
  static const double cameraDepth = 0.84; // 1 / tan(100deg / 2)
  static const double playerZ = cameraHeight * cameraDepth;
  static const int drawDistance = 250;
  static const int rumbleLength = 3;
  static const int lanes = 3;
  static const double horizonRatio = 0.42;

  static const double maxSpeed = segmentLength * 60; // 60 segments / second
  static const double accel = maxSpeed / 5;
  static const double braking = -maxSpeed;
  static const double decel = -maxSpeed / 5;
  static const double offRoadDecel = -maxSpeed / 2;
  static const double offRoadLimit = maxSpeed / 4;
  static const double centrifugal = 0.3;

  // ---- Rider state (written by RoadGame, read by RiderComponent) ----------
  double trkPosition = 0; // distance along the track
  double playerX = 0; // -1 .. +1 is on the tarmac
  double speed = 0;
  double steer = 0; // -1 left, 0 straight, +1 right
  bool throttle = true;
  bool brake = false;

  double get speedPercent => speed / maxSpeed;
  bool get offRoad => playerX < -1 || playerX > 1;

  // ---- Track --------------------------------------------------------------
  final List<_Segment> _segments = [];
  double _lastY = 0;
  late final double trackLength;

  void _addSegment(double curve, double y) {
    _segments.add(_Segment(_segments.length, _lastY, y, curve));
    _lastY = y;
  }

  static double _easeIn(double a, double b, double p) => a + (b - a) * p * p;
  static double _easeInOut(double a, double b, double p) =>
      a + (b - a) * (-math.cos(p * math.pi) / 2 + 0.5);

  void _addRoad(int enter, int hold, int leave, double curve, double hill) {
    final startY = _lastY;
    final endY = startY + hill * segmentLength;
    final total = enter + hold + leave;
    for (var n = 0; n < enter; n++) {
      _addSegment(_easeIn(0, curve, n / enter),
          _easeInOut(startY, endY, n / total));
    }
    for (var n = 0; n < hold; n++) {
      _addSegment(curve, _easeInOut(startY, endY, (enter + n) / total));
    }
    for (var n = 0; n < leave; n++) {
      _addSegment(_easeInOut(curve, 0, n / leave),
          _easeInOut(startY, endY, (enter + hold + n) / total));
    }
  }

  void _buildTrack() {
    // Hills sum to zero so the lap loops seamlessly.
    _addRoad(30, 40, 30, 0, 0); // warm-up straight
    _addRoad(40, 40, 40, 2, 0); // easy right
    _addRoad(25, 25, 25, 0, 20); // climb
    _addRoad(25, 25, 25, -3, -20); // left-hand descent
    _addRoad(40, 20, 40, 0, 0);
    _addRoad(20, 20, 20, 0, 40); // big crest
    _addRoad(30, 30, 30, 4, -40); // right-hander off the crest
    _addRoad(40, 40, 40, -5, 0); // hard left
    _addRoad(40, 40, 40, 3, 0); // sweeping right
    _addRoad(30, 40, 30, 0, 0);
    trackLength = _segments.length * segmentLength;
  }

  _Segment _segmentAt(double z) =>
      _segments[(z / segmentLength).floor() % _segments.length];

  // ---- Paints (created once) ----------------------------------------------
  static Paint _paint(Color c) => Paint()
    ..color = c
    ..isAntiAlias = false;

  final _skyPaint = _paint(const Color(0xFF6EC6FF));
  final _mountainPaint = _paint(const Color(0xFF5B7FA6));
  final _grassLight = _paint(const Color(0xFF2E9E3A));
  final _grassDark = _paint(const Color(0xFF278F33));
  final _rumbleLight = _paint(const Color(0xFFE53935));
  final _rumbleDark = _paint(const Color(0xFFF2F2F2));
  final _roadLight = _paint(const Color(0xFF6E6E73));
  final _roadDark = _paint(const Color(0xFF68686D));
  final _lanePaint = _paint(const Color(0xFFE8E8E8));
  final _sunPaint = Paint()..color = const Color(0xFFFFE9A8);

  final _path = Path();
  final _p1 = _P();
  final _p2 = _P();
  double _skyOffset = 0;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _skyPaint.shader = Gradient.linear(
      Offset.zero,
      Offset(0, size.y * horizonRatio),
      const [Color(0xFF3A8DDE), Color(0xFFBFE6FF)],
    );
  }

  // ---- Simulation ---------------------------------------------------------
  @override
  void update(double dt) {
    final playerSeg = _segmentAt(trkPosition + playerZ);
    final sp = speedPercent;

    trkPosition = (trkPosition + dt * speed) % trackLength;

    final dx = dt * 2 * sp;
    playerX += dx * steer;
    playerX -= dx * sp * playerSeg.curve * centrifugal;

    if (brake) {
      speed += braking * dt;
    } else if (throttle) {
      speed += accel * dt;
    } else {
      speed += decel * dt;
    }
    if (offRoad && speed > offRoadLimit) speed += offRoadDecel * dt;

    playerX = math.max(-2.0, math.min(2.0, playerX));
    speed = math.max(0.0, math.min(maxSpeed, speed));

    _skyOffset += playerSeg.curve * sp * dt * 40;
  }

  // ---- Rendering ----------------------------------------------------------
  void _project(_P p, double wy, double wz, double camX, double camY,
      double camZ) {
    final cz = wz - camZ;
    p.z = cz;
    final scale = cameraDepth / cz;
    p.x = size.x / 2 + scale * (0 - camX) * size.x / 2;
    p.y = size.y * horizonRatio - scale * (wy - camY) * size.y / 2;
    p.w = scale * roadWidth * size.x / 2;
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

  void _drawBackdrop(Canvas canvas) {
    final w = size.x;
    final horizon = size.y * horizonRatio;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, horizon + 1), _skyPaint);
    canvas.drawCircle(
        Offset(w * 0.72 + _skyOffset * 0.1, horizon * 0.55),
        horizon * 0.11,
        _sunPaint);

    // Parallax mountains: shift sideways as the road bends.
    final k = size.y / 700;
    _path.reset();
    _path.moveTo(0, horizon + 1);
    for (double x = 0; x <= w + 8; x += 8) {
      final s = x + _skyOffset;
      final y = horizon -
          (26 + 20 * math.sin(s * 0.011) + 11 * math.sin(s * 0.029)) * k;
      _path.lineTo(x, y);
    }
    _path.lineTo(w, horizon + 1);
    _path.close();
    canvas.drawPath(_path, _mountainPaint);

    canvas.drawRect(
        Rect.fromLTRB(0, horizon, w, size.y), _grassLight); // under the road
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0 || size.y <= 0) return;
    _drawBackdrop(canvas);

    final w = size.x;
    final baseIdx = (trkPosition / segmentLength).floor() % _segments.length;
    final base = _segments[baseIdx];
    final basePercent = (trkPosition % segmentLength) / segmentLength;

    final pz = trkPosition + playerZ;
    final playerSeg = _segmentAt(pz);
    final playerPercent = (pz % segmentLength) / segmentLength;
    final playerY =
        playerSeg.y1 + (playerSeg.y2 - playerSeg.y1) * playerPercent;

    var x = 0.0;
    var dx = -(base.curve * basePercent);
    var maxY = size.y;

    for (var n = 0; n < drawDistance; n++) {
      final seg = _segments[(baseIdx + n) % _segments.length];
      final looped = seg.index < baseIdx;

      final camX = playerX * roadWidth - x;
      final camY = playerY + cameraHeight;
      final camZ = trkPosition - (looped ? trackLength : 0);

      _project(_p1, seg.y1, seg.index * segmentLength, camX, camY, camZ);
      _project(
          _p2, seg.y2, (seg.index + 1) * segmentLength, camX - dx, camY, camZ);

      x += dx;
      dx += seg.curve;

      if (_p1.z <= cameraDepth || _p2.y >= _p1.y || _p2.y >= maxY) continue;

      final light = (seg.index ~/ rumbleLength).isEven;
      final x1 = _p1.x, y1 = _p1.y, w1 = _p1.w;
      final x2 = _p2.x, y2 = _p2.y, w2 = _p2.w;

      // Grass
      canvas.drawRect(Rect.fromLTRB(0, y2, w, y1 + 1),
          light ? _grassLight : _grassDark);

      // Rumble strips
      final r1 = w1 / math.max(6, 2 * lanes);
      final r2 = w2 / math.max(6, 2 * lanes);
      final rumble = light ? _rumbleLight : _rumbleDark;
      _poly(canvas, x1 - w1 - r1, y1, x1 - w1, y1, x2 - w2, y2, x2 - w2 - r2,
          y2, rumble);
      _poly(canvas, x1 + w1 + r1, y1, x1 + w1, y1, x2 + w2, y2, x2 + w2 + r2,
          y2, rumble);

      // Tarmac
      _poly(canvas, x1 - w1, y1, x1 + w1, y1, x2 + w2, y2, x2 - w2, y2,
          light ? _roadLight : _roadDark);

      // Lane markings (dashed: only on light bands)
      if (light) {
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

      maxY = y2;
    }
  }
}
