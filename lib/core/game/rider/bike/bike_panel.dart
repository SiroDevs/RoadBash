// Project imports:
part of '../rider_painter.dart';

class BikePanels extends RiderPartPainter {
  BikePanels(super.look);

  late final BikeMiddlePanels _middle = BikeMiddlePanels(look);

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final tail = tailLift(pose);
    _backSidePanels(paint, path, canva, pose, tail);
    _middle.paint(paint, path, canva, pose, tail);
    _smallPanels(paint, path, canva, pose, tail);
  }

  void _backSidePanels(
    Paint paint,
    Path path,
    Canvas canva,
    RiderPose pose,
    double tail,
  ) {
    // Back Side Right Panel
    path
      ..reset()
      ..moveTo(73.0, 67.0)
      ..lineTo(79.0, 65.0)
      ..lineTo(85.0, 53.0)
      ..lineTo(82.0, 47.0)
      ..lineTo(76.0, 34.0)
      ..lineTo(74.0, 34.0)
      ..lineTo(76.0, 41.0)
      ..lineTo(77.0, 46.0)
      ..lineTo(78.0, 50.0)
      ..lineTo(76.0, 57.0)
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
    // Back Side Left Panel
    path
      ..reset()
      ..moveTo(48.0, 67.0)
      ..lineTo(42.0, 64.0)
      ..lineTo(36.0, 53.0)
      ..lineTo(37.0, 49.0)
      ..lineTo(40.0, 46.0)
      ..lineTo(44.0, 36.0)
      ..lineTo(46.0, 34.0)
      ..lineTo(47.0, 36.0)
      ..lineTo(43.0, 45.0)
      ..lineTo(43.0, 50.0)
      ..lineTo(46.0, 62.0)
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
  }

  void _smallPanels(
    Paint paint,
    Path path,
    Canvas canva,
    RiderPose pose,
    double tail,
  ) {
    // Back Small Right Panel
    path
      ..reset()
      ..moveTo(76.0, 43.0)
      ..lineTo(72.0, 44.0)
      ..lineTo(73.0, 50.0)
      ..lineTo(76.0, 51.0)
      ..lineTo(77.0, 51.0)
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
    // Back Small Left Panel
    path
      ..reset()
      ..moveTo(47.0, 50.0)
      ..lineTo(44.0, 50.0)
      ..lineTo(44.0, 44.0)
      ..lineTo(45.0, 41.0)
      ..lineTo(48.0, 44.0)
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
  }
}
