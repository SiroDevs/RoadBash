// Project imports:
part of '../rider_painter.dart';

/// Everything the rider wears: legs, torso, arms and helmet.
class LowerBody extends RiderPartPainter {
  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _leftLeg(paint, path, canva, pose);
    _rightLeg(paint, path, canva, pose);
  }

  /// Left leg swings out and down as the bike comes to a stop.
  void _leftLeg(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final f = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * f;

    final kick = -5 * math.sin(math.pi * f);

    // Left Thigh
    path
      ..reset()
      ..moveTo(m(31, 25), m(58, 64))
      ..lineTo(m(46, 42), m(33, 35))
      ..lineTo(m(36, 32), m(16, 18))
      ..lineTo(m(15, 9), m(51, 56))
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

    // Left Leg
    path
      ..reset()
      ..moveTo(m(36, 11) + kick, m(85, 100))
      ..lineTo(m(33, 25), m(54, 64))
      ..lineTo(m(15, 9), m(51, 56))
      ..lineTo(m(21, -2) + kick, m(86, 98))
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

    // Left Boot
    path
      ..reset()
      ..moveTo(m(20, -1) + kick, m(77, 95))
      ..lineTo(m(35, 13) + kick, m(76, 95))
      ..lineTo(m(38, 3) + kick, m(96, 125))
      ..lineTo(m(23, -8) + kick, m(97, 123))
      ..lineTo(m(15, -15) + kick, m(91, 117))
      ..lineTo(m(15, -15) + kick, m(84, 110))
      ..lineTo(m(21, -5) + kick, m(85, 110))
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
  }

  /// Right leg stays tucked against the tank.
  void _rightLeg(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final f = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * f;

    // Right Thigh
    path
      ..reset()
      ..moveTo(m(89, 87), m(60, 56))
      ..lineTo(m(76, 73), m(33, 32))
      ..lineTo(m(85, 82), m(15, 13))
      ..lineTo(105.0, m(52, 50))
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

    // Right Leg
    path
      ..reset()
      ..moveTo(80.0, 88.0)
      ..lineTo(m(88, 87), m(57, 55))
      ..lineTo(105.0, m(51, 50))
      ..lineTo(94.0, 90.0)
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

    // Right Boot
    path
      ..reset()
      ..moveTo(m(82, 84), 78.0)
      ..lineTo(m(81, 81), m(94, 97))
      ..lineTo(m(95, 96), 95.0)
      ..lineTo(m(102, 102), m(87, 90))
      ..lineTo(m(103, 103), m(82, 85))
      ..lineTo(m(94, 95), m(83, 86))
      ..lineTo(m(94, 97), 77.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
  }
}
