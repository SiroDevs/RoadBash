// Project imports:
part of '../rider_painter.dart';

/// Everything the rider wears: legs, torso, arms and helmet.
class UpperBody extends RiderPartPainter {
  static const _helmetShell = Color(0xFFF2C21C);
  static const _helmetShade = Color(0xFFC79A0F);
  static const _helmetGloss = Color(0x66FFFFFF);

  static const double _mid = RiderPartPainter.midX;

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _helmet(canva, pose);
    _torso(paint, path, canva, pose);
    _arms(paint, path, canva, pose);
  }

  void _helmet(Canvas canva, RiderPose pose) {
    final neckY = 15 + tuckOf(pose);
    final f = pose.foot.clamp(0.0, 1.0);
    double m(double moving, double stopped) => moving + (stopped - moving) * f;

    fill(
      canva,
      Rect.fromLTRB(
        53,
        m(neckY - 30, neckY - 40),
        67,
        m(neckY - 20, neckY - 30),
      ),
      RiderPartPainter.leather,
      5,
    );

    canva.save();
    canva.translate(_mid, neckY);
    canva.rotate(-pose.lean * 0.3);
    canva.translate(-_mid, -neckY);

    final cy = neckY - 45;
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(_mid, m(cy, cy - 10)),
        width: 30,
        height: 32,
      ),
      _helmetShell,
    );
    quad(canva, _helmetShade, [
      Offset(_mid - 13, m(cy + 8, cy)),
      Offset(_mid + 13, m(cy + 8, cy)),
      Offset(_mid + 8, m(cy + 15, cy + 7)),
      Offset(_mid - 8, m(cy + 15, cy + 7)),
    ]);
    fill(
      canva,
      Rect.fromLTRB(
        _mid - 5,
        m(cy - 13, cy - 20),
        _mid + 10,
        m(cy - 5, cy - 12),
      ),
      _helmetShade,
      5,
    );
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(_mid - 5, m(cy - 5, cy - 12)),
        width: 15,
        height: 11,
      ),
      _helmetGloss,
    );
    canva.restore();
  }

  void _torso(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final f = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * f;

    path
      ..reset()
      ..moveTo(m(46, 41), m(34, 35))
      ..lineTo(m(36, 32), m(16, 17))
      ..lineTo(36.0, 5.0)
      ..lineTo(m(31, 31.0), m(-11, -18.0))
      ..lineTo(m(38, 38.0), m(-17, -24.0))
      ..lineTo(m(46, 46.0), m(-18, -25.0))
      ..lineTo(m(62, 62.0), m(-16, -23.0))
      ..lineTo(m(76, 76.0), m(-17, -24.0))
      ..lineTo(m(83, 84), m(-14, -21))
      ..lineTo(m(88, 89), m(-9, -16))
      ..lineTo(m(85, 81), m(7, 6))
      ..lineTo(m(85, 82), m(15, 16))
      ..lineTo(m(77, 73), m(34, 33))
      ..lineTo(67.0, 30.0)
      ..lineTo(55.0, 30.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFA349A4);
    canva.drawPath(path, paint);

    // Back Reflector 1
    path
      ..reset()
      ..moveTo(36.0, -3.0)
      ..lineTo(34.0, -11.0)
      ..lineTo(43.0, -13.0)
      ..lineTo(69.0, -12.0)
      ..lineTo(79.0, -8.0)
      ..lineTo(79.0, -1.0)
      ..lineTo(71.0, -4.0)
      ..lineTo(45.0, -5.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF22B14C);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFFB5E61D);
    canva.drawPath(path, paint);
    // Back Reflector 2
    path
      ..reset()
      ..moveTo(44.0, -4.0)
      ..lineTo(41.0, 9.0)
      ..lineTo(45.0, 20.0)
      ..lineTo(53.0, 18.0)
      ..lineTo(64.0, 18.0)
      ..lineTo(71.0, 21.0)
      ..lineTo(74.0, 9.0)
      ..lineTo(71.0, -3.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF880015);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..color = const Color(0xFFB5E61D);
    canva.drawPath(path, paint);
  }

  /// Sleeves and gloves, reaching for the grips [RiderBike] draws over them.
  void _arms(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final f = pose.foot.clamp(0.0, 1.0);

    // Blends one coordinate: f = 0 gives the moving value, f = 1 gives the stopped value.
    double m(double moving, double stopped) => moving + (stopped - moving) * f;

    // Right Hand
    path
      ..reset()
      ..moveTo(m(85, 81), m(15, 12))
      ..lineTo(97.0, 38.0)
      ..lineTo(106.0, 38.0)
      ..lineTo(111.0, 35.0)
      ..lineTo(111.0, 26.0)
      ..lineTo(110.0, 22.0)
      ..lineTo(106.0, 22.0)
      ..lineTo(95.0, -3.0)
      ..lineTo(m(88, 89), m(-9, -15))
      ..lineTo(m(85, 81), m(7, 2))
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFA349A4);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
    // Right Hand Reflector
    path
      ..reset()
      ..moveTo(79.0, 0.0)
      ..lineTo(96.0, 35.0)
      ..lineTo(100.0, 35.0)
      ..lineTo(80.0, -8.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF22B14C);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFFB5E61D);
    canva.drawPath(path, paint);

    // Left Hand
    path
      ..reset()
      ..moveTo(m(36, 33), 16.0)
      ..lineTo(m(27, 24), 30.0)
      ..lineTo(m(19, 16), 34.0)
      ..lineTo(m(11, 8), 31.0)
      ..lineTo(m(10, 7), 20.0)
      ..lineTo(m(12, 9), 16.0)
      ..lineTo(m(17, 14), 14.0)
      ..lineTo(31.0, m(-11, -18))
      ..lineTo(36.0, 5.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFA349A4);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);

    // Left Hand Reflector
    path
      ..reset()
      ..moveTo(32.0, -10.0)
      ..lineTo(11.0, 30.0)
      ..lineTo(15.0, 32.0)
      ..lineTo(34.0, -3.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF22B14C);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = const Color(0xFFB5E61D);
    canva.drawPath(path, paint);
  }
}
