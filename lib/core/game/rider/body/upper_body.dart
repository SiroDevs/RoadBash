// Project imports:
part of '../rider_painter.dart';

/// Paints the rider's helmet, torso and arms.
class UpperBody extends RiderPartPainter {
  UpperBody(super.look);

  late final Helmet _helmet = Helmet(look);

  /// Paints the helmet, torso and arms.
  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _helmet.paint(canva, pose);
    _torso(paint, path, canva, pose);
    _arms(paint, path, canva, pose);
  }

  /// Paints the torso.
  void _torso(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final foot = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * foot;

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
      ..color = look.suit;
    canva.drawPath(path, paint);

    // Back Reflector
    path
      ..reset()
      ..moveTo(39.0, -3.0)
      ..lineTo(37.0, -11.0)
      ..lineTo(46.0, -13.0)
      ..lineTo(72.0, -12.0)
      ..lineTo(82.0, -8.0)
      ..lineTo(82.0, -1.0)
      ..lineTo(74.0, -4.0)
      ..lineTo(73.0, -3.0)
      ..lineTo(76.0, 9.0)
      ..lineTo(73.0, 21.0)
      ..lineTo(66.0, 18.0)
      ..lineTo(55.0, 18.0)
      ..lineTo(47.0, 20.0)
      ..lineTo(43.0, 9.0)
      ..lineTo(46.0, -4.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = look.backPatch;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..color = look.stripeEdge;
    canva.drawPath(path, paint);
  }

  /// Paints the arms and hands.
  void _arms(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final foot = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * foot;

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
      ..color = look.suit;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
    // Right Hand Reflector
    path
      ..reset()
      ..moveTo(80.0, -2.0)
      ..lineTo(100.0, 38.0)
      ..lineTo(104.0, 35.0)
      ..lineTo(83.0, -6.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = look.stripe;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = look.stripeEdge;
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
      ..color = look.suit;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);

    // Left Hand Reflector
    path
      ..reset()
      ..moveTo(38.0, -11.0)
      ..lineTo(11.0, 30.0)
      ..lineTo(15.0, 32.0)
      ..lineTo(38.0, -3.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = look.stripe;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = look.stripeEdge;
    canva.drawPath(path, paint);
  }
}
