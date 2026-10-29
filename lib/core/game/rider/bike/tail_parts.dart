// Project imports:
part of '../rider_painter.dart';

class TailParts extends RiderPartPainter {
  TailParts(super.look);

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final tail = tailLift(pose);
    _tailUnit(paint, path, canva, pose, tail);
    _tailCovers(paint, path, canva, pose, tail);
    _exhaustPanel(paint, path, canva, tail);
  }

  void paintWheel(Paint paint, Canvas canva, RiderPose pose) {
    _rearWheel(paint, canva, pose);
  }
  
  void _tailUnit(Paint paint, Path path, Canvas canva, RiderPose pose, double tail) {
    // Brake Light
    path
      ..reset()
      ..moveTo(48.0, 35.0)
      ..lineTo(52.0, 43.0)
      ..lineTo(60.0, 42.0)
      ..lineTo(68.0, 43.0)
      ..lineTo(72.0, 35.0)
      ..lineTo(63.0, 32.0)
      ..lineTo(64.0, 36.0)
      ..lineTo(60.0, 37.0)
      ..lineTo(56.0, 36.0)
      ..lineTo(57.0, 32.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.brakeLight;
    canva.drawPath(path, paint);

    // Back Seat Handle
    path
      ..reset()
      ..moveTo(45.0, 34.0)
      ..lineTo(46.0, 34.0)
      ..lineTo(47.0, 36.0)
      ..lineTo(60.0, 32.0)
      ..lineTo(60.0, 32.0)
      ..lineTo(71.0, 35.0)
      ..lineTo(74.0, 36.0)
      ..lineTo(76.0, 34.0)
      ..lineTo(67.0, 29.0)
      ..lineTo(60.0, 28.0)
      ..lineTo(53.0, 29.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Rear Bumper
    path
      ..reset()
      ..moveTo(51.0, 57.0)
      ..lineTo(52.0, 43.0)
      ..lineTo(60.0, 42.0)
      ..lineTo(68.0, 43.0)
      ..lineTo(69.0, 57.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panel;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawPath(path, paint);
    // Brake Light Node
    path
      ..reset()
      ..moveTo(57.0, 33.0)
      ..lineTo(56.0, 37.0)
      ..lineTo(60.0, 38.0)
      ..lineTo(64.0, 37.0)
      ..lineTo(63.0, 33.0)
      ..lineTo(60.0, 32.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Rear Outer Bumper
    path
      ..reset()
      ..moveTo(54.0, 57.0)
      ..lineTo(57.0, 49.0)
      ..lineTo(63.0, 49.0)
      ..lineTo(66.0, 57.0)
      ..lineTo(66.0, 57.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
  }

  void _tailCovers(Paint paint, Path path, Canvas canva, RiderPose pose, double tail) {
   // Left Hollow Part
    path
      ..reset()
      ..moveTo(47.0, 68.0)
      ..lineTo(45.0, 74.0)
      ..lineTo(41.0, 76.0)
      ..lineTo(34.0, 76.0)
      ..lineTo(31.0, 73.0)
      ..lineTo(30.0, 69.0)
      ..lineTo(30.0, 65.0)
      ..lineTo(30.0, 63.0)
      ..lineTo(32.0, 58.0)
      ..lineTo(35.0, 55.0)
      ..lineTo(38.0, 56.0)
      ..lineTo(36.0, 60.0)
      ..lineTo(36.0, 64.0)
      ..lineTo(38.0, 66.0)
      ..lineTo(41.0, 67.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panel;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawPath(path, paint);
    // Left Hollow Cover
    path
      ..reset()
      ..moveTo(47.0, 69.0)
      ..lineTo(39.0, 71.0)
      ..lineTo(33.0, 68.0)
      ..lineTo(30.0, 65.0)
      ..lineTo(30.0, 60.0)
      ..lineTo(34.0, 56.0)
      ..lineTo(37.0, 55.0)
      ..lineTo(38.0, 56.0)
      ..lineTo(36.0, 61.0)
      ..lineTo(36.0, 64.0)
      ..lineTo(39.0, 67.0)
      ..lineTo(44.0, 68.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawPath(path, paint);
    // Back Under panel
    path
      ..reset()
      ..moveTo(49.0, 79.0)
      ..lineTo(48.0, 67.0)
      ..lineTo(51.0, 57.0)
      ..lineTo(51.0, 57.0)
      ..lineTo(69.0, 57.0)
      ..lineTo(71.0, 67.0)
      ..lineTo(71.0, 67.0)
      ..lineTo(70.0, 79.0)
      ..lineTo(69.0, 79.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawPath(path, paint);
  }

  void _exhaustPanel(Paint paint, Path path, Canvas canva, double tail) {
    // Exhaust Panel
    path
      ..reset()
      ..moveTo(71.0, 105.0)
      ..lineTo(84.0, 91.0)
      ..lineTo(82.0, 95.0)
      ..lineTo(81.0, 99.0)
      ..lineTo(82.0, 103.0)
      ..lineTo(84.0, 106.0)
      ..lineTo(87.0, 106.0)
      ..lineTo(71.0, 120.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFFFFFFF);
    canva.drawPath(path, paint);
    // Exhaust Hole
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawOval(const Rect.fromLTRB(81.0, 91.0, 89.0, 107.0), paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFFFFFFF);
    canva.drawOval(const Rect.fromLTRB(81.0, 91.0, 89.0, 107.0), paint);
    // Exhaust Inner Hole
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panelDark;
    canva.drawOval(const Rect.fromLTRB(82.0, 94.0, 88.0, 105.0), paint);
  }

  void _rearWheel(Paint paint, Canvas canva, RiderPose pose) {
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canva.drawRRect(
      RRect.fromRectXY(
        const Rect.fromLTRB(48.0, 78.0, 72.0, 164.0),
        11.5,
        11.5,
      ),
      paint,
    );
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawRRect(
      RRect.fromRectXY(
        const Rect.fromLTRB(48.0, 78.0, 72.0, 164.0),
        11.5,
        11.5,
      ),
      paint,
    );
  }

}
