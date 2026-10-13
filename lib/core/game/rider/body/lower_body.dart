// Project imports:
part of '../rider_painter.dart';

/// Everything the rider wears: legs, torso, arms and helmet.
class LowerBody extends RiderPartPainter {

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _leftLeg(paint, path, canva);
    _rightLeg(paint, path, canva);
  }

  void _leftLeg(Paint paint, Path path, Canvas canva) {
    // Left Leg
    path
      ..reset()
      ..moveTo(32.0, 21.0)
      ..lineTo(44.0, 34.0)
      ..lineTo(28.0, 66.0)
      ..lineTo(33.0, 81.0)
      ..lineTo(21.0, 86.0)
      ..lineTo(11.0, 60.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC63F96);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
  }

  void _rightLeg(Paint paint, Path path, Canvas canva) {
    // Right Leg
    path
      ..reset()
      ..moveTo(87.0, 16.0)
      ..lineTo(77.0, 34.0)
      ..lineTo(93.0, 60.0)
      ..lineTo(87.0, 76.0)
      ..lineTo(99.0, 83.0)
      ..lineTo(114.0, 56.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC63F96);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
  }
}
