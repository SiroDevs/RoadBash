// Project imports:
part of '../rider_painter.dart';

class TailCovers extends RiderPartPainter {
  TailCovers(super.look);

  void paint(
    Paint paint,
    Path path,
    Canvas canva,
    RiderPose pose,
    double tail,
  ) {
    _tailCovers(paint, path, canva, pose, tail);
    _exhaustPanel(paint, path, canva, tail);
  }

  void _tailCovers(
    Paint paint,
    Path path,
    Canvas canva,
    RiderPose pose,
    double tail,
  ) {
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
}
