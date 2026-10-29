// Project imports:
part of '../rider_painter.dart';

/// Paints the middle fairing panels of the bike.
class BikeMiddlePanels extends RiderPartPainter {
  BikeMiddlePanels(super.look);

  /// Paints the middle panels.
  void paint(
    Paint paint,
    Path path,
    Canvas canva,
    RiderPose pose,
    double tail,
  ) {
    // Middle Right Panel
    path
      ..reset()
      ..moveTo(89.0, 71.0)
      ..lineTo(88.0, 69.0)
      ..lineTo(84.0, 74.0)
      ..lineTo(80.0, 74.0)
      ..lineTo(76.0, 74.0)
      ..lineTo(78.0, 84.0)
      ..lineTo(78.0, 92.0)
      ..lineTo(85.0, 91.0)
      ..lineTo(86.0, 83.0)
      ..lineTo(89.0, 75.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panel;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Back Left Bottom Panel
    path
      ..reset()
      ..moveTo(49.0, 79.0)
      ..lineTo(43.0, 82.0)
      ..lineTo(39.0, 87.0)
      ..lineTo(38.0, 92.0)
      ..lineTo(37.0, 98.0)
      ..lineTo(41.0, 103.0)
      ..lineTo(43.0, 105.0)
      ..lineTo(44.0, 98.0)
      ..lineTo(47.0, 98.0)
      ..lineTo(48.0, 92.0)
      ..lineTo(45.0, 87.0)
      ..lineTo(46.0, 84.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.panel;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Small Part Right 2
    path
      ..reset()
      ..moveTo(87.0, 65.0)
      ..lineTo(82.0, 68.0)
      ..lineTo(79.0, 71.0)
      ..lineTo(81.0, 72.0)
      ..lineTo(87.0, 69.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.trim;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Green Right Part
    path
      ..reset()
      ..moveTo(84.0, 55.0)
      ..lineTo(85.0, 60.0)
      ..lineTo(86.0, 63.0)
      ..lineTo(85.0, 66.0)
      ..lineTo(79.0, 65.0)
      ..lineTo(80.0, 62.0)
      ..lineTo(83.0, 62.0)
      ..lineTo(82.0, 59.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.accent;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = bike.accentEdge;
    canva.drawPath(path, paint);
    // Green Left Part
    path
      ..reset()
      ..moveTo(48.0, 71.0)
      ..lineTo(41.0, 80.0)
      ..lineTo(40.0, 83.0)
      ..lineTo(43.0, 83.0)
      ..lineTo(47.0, 80.0)
      ..lineTo(49.0, 77.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.accent;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = bike.accentEdge;
    canva.drawPath(path, paint);
    // Small Middle Left Part
    path
      ..reset()
      ..moveTo(36.0, 85.0)
      ..lineTo(35.0, 81.0)
      ..lineTo(36.0, 78.0)
      ..lineTo(39.0, 78.0)
      ..lineTo(39.0, 84.0)
      ..lineTo(38.0, 88.0)
      ..lineTo(37.0, 96.0)
      ..lineTo(35.0, 94.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.trim;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
    // Back Right Bottom Panel
    path
      ..reset()
      ..moveTo(79.0, 94.0)
      ..lineTo(78.0, 81.0)
      ..lineTo(75.0, 73.0)
      ..lineTo(73.0, 70.0)
      ..lineTo(72.0, 73.0)
      ..lineTo(73.0, 80.0)
      ..lineTo(73.0, 88.0)
      ..lineTo(76.0, 93.0)
      ..lineTo(75.0, 98.0)
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
    // Small Right Part 1
    path
      ..reset()
      ..moveTo(72.0, 69.0)
      ..lineTo(76.0, 74.0)
      ..lineTo(78.0, 74.0)
      ..lineTo(79.0, 71.0)
      ..lineTo(76.0, 67.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.trim;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF000000);
    canva.drawPath(path, paint);
  }
}
