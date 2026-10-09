// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'rider_pose.dart';

class RiderPainter {
  static const double width = 120;
  static const double height = 170;
  static const double _ground = 166;
  static const double _mid = width / 2;

  // Leathers and bodywork.
  static const _helmetShell = Color(0xFFF2C21C);
  static const _helmetShade = Color(0xFFC79A0F);
  static const _helmetGloss = Color(0x66FFFFFF);
  static const _suitMain = Color(0xFFC63F96);
  static const _suitPanel = Color(0xFFE9E3F0);
  static const _suitTrim = Color(0xFFF2C21C);
  static const _suitLower = Color(0xFFE8551D);
  static const _leather = Color(0xFF23242B);
  static const _bodywork = Color(0xFFC9222B);
  static const _bodyShade = Color(0xFF8E1820);
  static const _chrome = Color(0xFFB9BEC6);
  static const _chromeDark = Color(0xFF6E737B);
  static const _tyre = Color(0xFF151518);
  static const _tread = Color(0x40FFFFFF);
  static const _shadowInk = Color(0x4D000000);

  final Paint _p = Paint()..isAntiAlias = true;
  final Path _path = Path();

  void _fill(Canvas c, Rect r, Color color, [double radius = 3]) {
    _p
      ..style = PaintingStyle.fill
      ..color = color;
    c.drawRRect(RRect.fromRectXY(r, radius, radius), _p);
  }

  void _oval(Canvas c, Rect r, Color color) {
    _p
      ..style = PaintingStyle.fill
      ..color = color;
    c.drawOval(r, _p);
  }

  void _quad(Canvas c, Color color, List<Offset> pts) {
    _p
      ..style = PaintingStyle.fill
      ..color = color;
    _path.reset();
    _path.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      _path.lineTo(pts[i].dx, pts[i].dy);
    }
    _path.close();
    c.drawPath(_path, _p);
  }

  void _limb(Canvas c, Offset a, Offset b, double w, Color color) {
    _p
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = color;
    c.drawLine(a, b, _p);
    _p.style = PaintingStyle.fill;
  }

  void paint(Canvas c, RiderPose p) {
    _contactShadow(c, p);

    c.save();
    c.translate(_mid + p.shake, _ground);
    c.rotate(p.lean);
    c.translate(-_mid, -_ground + p.bob);

    // Braking lifts the tail toward the camera; power squats it down.
    final tail = -p.pitch * 3.5;

    _rearWheel(c, p);
    _exhausts(c, tail);
    _tailUnit(c, p, tail);
    _legs(c, p, tail);
    _torso(c, p);
    _arms(c, p);
    _head(c, p);
    c.restore();
  }

  /// Stays flat on the road while the bike banks over it.
  void _contactShadow(Canvas c, RiderPose p) {
    final slip = p.lean * 46;
    final squash = 1 - p.lean.abs() * 0.5;
    _oval(
      c,
      Rect.fromCenter(
        center: Offset(_mid + slip * 0.5, _ground + 4),
        width: 96 * squash,
        height: 15,
      ),
      _shadowInk,
    );
  }

  void _rearWheel(Canvas c, RiderPose p) {
    _fill(c, const Rect.fromLTRB(48, 96, 72, 164), _tyre, 10);

    // Tread marks run up the back face as the wheel turns forward. They wash
    // out as the wheel spins up, which is what sells the speed.
    final contrast = (1 - p.speed * 0.75).clamp(0.18, 1.0);
    _p
      ..style = PaintingStyle.fill
      ..color = Color.lerp(const Color(0x00FFFFFF), _tread, contrast)!;
    for (var n = 0; n < 6; n++) {
      final y = 100 + ((n * 11.0 - p.phase * 66) % 66);
      c.drawRect(Rect.fromLTWH(50, y, 20, 2.4), _p);
    }

    // Sliver of rim either side of the carcass.
    _fill(c, const Rect.fromLTRB(46, 118, 50, 146), _chromeDark, 2);
    _fill(c, const Rect.fromLTRB(70, 118, 74, 146), _chromeDark, 2);
  }

  void _exhausts(Canvas c, double tail) {
    for (final side in const [-1, 1]) {
      final cx = _mid + side * 25.0;
      _fill(c, Rect.fromLTRB(cx - 11, 112 + tail, cx + 11, 132 + tail), _chrome,
          8);
      _oval(
          c,
          Rect.fromCenter(
              center: Offset(cx, 123 + tail), width: 13, height: 15),
          _chromeDark);
      _oval(
          c,
          Rect.fromCenter(
              center: Offset(cx, 123 + tail), width: 8, height: 10),
          const Color(0xFF17181B));
    }
  }

  void _tailUnit(Canvas c, RiderPose p, double tail) {
    _quad(c, _bodyShade, [
      Offset(44, 118 + tail),
      Offset(76, 118 + tail),
      Offset(72, 142 + tail),
      Offset(48, 142 + tail),
    ]);
    _quad(c, _bodywork, [
      Offset(40, 84 + tail),
      Offset(80, 84 + tail),
      Offset(75, 122 + tail),
      Offset(45, 122 + tail),
    ]);

    final lit = p.braking;
    _fill(
      c,
      Rect.fromLTRB(49, 100 + tail, 71, 113 + tail),
      lit ? const Color(0xFFFF2B21) : const Color(0xFF9E1C18),
      4,
    );
    if (lit) {
      _oval(
        c,
        Rect.fromCenter(
            center: Offset(_mid, 106 + tail), width: 42, height: 26),
        const Color(0x4DFF3A2A),
      );
    }
    _fill(c, Rect.fromLTRB(52, 138 + tail, 68, 150 + tail),
        const Color(0xFFDCDCDE), 2);
  }

  void _legs(Canvas c, RiderPose p, double tail) {
    // Right leg stays tucked against the tank.
    _quad(c, _leather, [
      Offset(72, 74),
      Offset(88, 78),
      Offset(86, 112 + tail),
      Offset(71, 108 + tail),
    ]);
    _fill(c, Rect.fromLTRB(70, 106 + tail, 88, 120 + tail),
        const Color(0xFF131316), 4);

    // Left leg swings out and down as the bike comes to a stop.
    final drop = 34 * p.foot;
    c.save();
    c.translate(40, 72);
    c.rotate(0.5 * p.foot);
    c.translate(-40, -72);
    _quad(c, _leather, [
      const Offset(32, 78),
      const Offset(48, 74),
      Offset(49, 108 + tail + drop),
      Offset(34, 112 + tail + drop),
    ]);
    _fill(c, Rect.fromLTRB(32, 106 + tail + drop, 50, 120 + tail + drop),
        const Color(0xFF131316), 4);
    c.restore();
  }

  void _torso(Canvas c, RiderPose p) {
    // Tucking at speed drops and broadens the back.
    final tuck = p.speed * 5;

    _quad(c, _suitLower, [
      Offset(43, 86 + tuck * 0.4),
      Offset(77, 86 + tuck * 0.4),
      const Offset(74, 104),
      const Offset(46, 104),
    ]);

    _path.reset();
    _path
      ..moveTo(30, 48 + tuck)
      ..cubicTo(26, 70 + tuck, 40, 80 + tuck, 43, 92 + tuck * 0.4)
      ..lineTo(77, 92 + tuck * 0.4)
      ..cubicTo(80, 80 + tuck, 94, 70 + tuck, 90, 48 + tuck)
      ..close();
    _p
      ..style = PaintingStyle.fill
      ..color = _suitMain;
    c.drawPath(_path, _p);

    // Spine panel.
    _quad(c, _suitPanel, [
      Offset(52, 50 + tuck),
      Offset(68, 50 + tuck),
      Offset(70, 90 + tuck * 0.4),
      Offset(50, 90 + tuck * 0.4),
    ]);

    // Shoulder armour.
    _fill(c, Rect.fromLTRB(27, 44 + tuck, 49, 64 + tuck), _suitTrim, 9);
    _fill(c, Rect.fromLTRB(71, 44 + tuck, 93, 64 + tuck), _suitTrim, 9);
    _fill(c, Rect.fromLTRB(44, 42 + tuck, 76, 56 + tuck), _suitMain, 7);
  }

  void _arms(Canvas c, RiderPose p) {
    final tuck = p.speed * 5;
    // The bars turn with the input, so the hands are not quite level.
    final twist = p.steer * 4;

    for (final side in const [-1, 1]) {
      final shoulder = Offset(_mid + side * 26, 54 + tuck);
      final hand = Offset(_mid + side * 44, 78 + tuck + side * twist);
      _limb(c, shoulder, hand, 13, _suitMain);
      _limb(c, shoulder, hand, 7, _suitTrim);
      _oval(
          c,
          Rect.fromCenter(
              center: hand, width: 15, height: 13),
          const Color(0xFF191A1E));

      // Bar end and mirror stalk poking past the hand.
      final tip = Offset(hand.dx + side * 9, hand.dy - 2);
      _limb(c, hand, tip, 5, _chromeDark);
      _oval(
          c,
          Rect.fromCenter(
              center: Offset(tip.dx + side * 2, tip.dy - 13),
              width: 13,
              height: 9),
          _leather);
      _limb(c, tip, Offset(tip.dx + side * 2, tip.dy - 10), 3, _chromeDark);
    }
  }

  void _head(Canvas c, RiderPose p) {
    final tuck = p.speed * 5;
    final neckY = 44 + tuck;

    _fill(c, Rect.fromLTRB(53, neckY - 8, 67, neckY + 6), _leather, 5);

    c.save();
    c.translate(_mid, neckY);
    // The head stays a little more upright than the bike.
    c.rotate(-p.lean * 0.3);
    c.translate(-_mid, -neckY);

    final cy = neckY - 20;
    _oval(c, Rect.fromCenter(center: Offset(_mid, cy), width: 42, height: 44),
        _helmetShell);
    // Shaded underside and the back vent.
    _quad(c, _helmetShade, [
      Offset(_mid - 19, cy + 6),
      Offset(_mid + 19, cy + 6),
      Offset(_mid + 15, cy + 20),
      Offset(_mid - 15, cy + 20),
    ]);
    _fill(c, Rect.fromLTRB(_mid - 9, cy - 20, _mid + 9, cy - 8), _helmetShade,
        5);
    _oval(
        c,
        Rect.fromCenter(
            center: Offset(_mid - 9, cy - 9), width: 15, height: 11),
        _helmetGloss);
    c.restore();
  }

  /// Lean the painter will accept before the shadow maths stops behaving.
  static const double maxLean = math.pi / 7;
}
