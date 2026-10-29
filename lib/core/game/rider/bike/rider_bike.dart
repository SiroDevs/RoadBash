// Project imports:
part of '../rider_painter.dart';

class RiderBike extends RiderPartPainter {
  RiderBike(super.look);

  void paintShadow(Canvas canva, RiderPose pose) {
    final slip = pose.lean * 46;
    final squash = 1 - pose.lean.abs() * 0.5;
    oval(
      canva,
      Rect.fromCenter(
        center: Offset(
          RiderPartPainter.midX + slip * 0.5,
          RiderPartPainter.groundY + 4,
        ),
        width: 96 * squash,
        height: 15,
      ),
      Color(0x4D000000),
    );
  }

  void handleBars(Paint paint, Path path, Canvas canva, RiderPose pose) {
    // Left Handle
    path
      ..reset()
      ..moveTo(39.0, 38.0)
      ..lineTo(29.0, 42.0)
      ..lineTo(27.0, 41.0)
      ..lineTo(27.0, 38.0)
      ..lineTo(34.0, 37.0)
      ..lineTo(40.0, 30.0)
      ..lineTo(32.0, 28.0)
      ..lineTo(25.0, 25.0)
      ..lineTo(22.0, 27.0)
      ..lineTo(20.0, 24.0)
      ..lineTo(22.0, 21.0)
      ..lineTo(40.0, 24.0)
      ..lineTo(42.0, 26.0)
      ..lineTo(44.0, 30.0)
      ..lineTo(42.0, 33.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.frame;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
    
    // Right Handle
    path
      ..reset()
      ..moveTo(87.0, 37.0)
      ..lineTo(93.0, 40.0)
      ..lineTo(95.0, 38.0)
      ..lineTo(87.0, 33.0)
      ..lineTo(84.0, 29.0)
      ..lineTo(82.0, 27.0)
      ..lineTo(90.0, 24.0)
      ..lineTo(96.0, 21.0)
      ..lineTo(99.0, 23.0)
      ..lineTo(100.0, 20.0)
      ..lineTo(98.0, 17.0)
      ..lineTo(81.0, 20.0)
      ..lineTo(79.0, 23.0)
      ..lineTo(78.0, 27.0)
      ..lineTo(82.0, 33.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.frame;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFF7F7F7F);
    canva.drawPath(path, paint);
  }

  void paintBody(Paint paint, Path path, Canvas canva, RiderPose pose) {
    path
      ..reset()
      ..moveTo(46.0, 32.0)
      ..lineTo(54.0, 29.0)
      ..lineTo(64.0, 29.0)
      ..lineTo(75.0, 32.0)
      ..lineTo(81.0, 37.0)
      ..lineTo(84.0, 45.0)
      ..lineTo(88.0, 47.0)
      ..lineTo(89.0, 52.0)
      ..lineTo(91.0, 53.0)
      ..lineTo(91.0, 60.0)
      ..lineTo(88.0, 63.0)
      ..lineTo(87.0, 65.0)
      ..lineTo(88.0, 68.0)
      ..lineTo(87.0, 73.0)
      ..lineTo(87.0, 78.0)
      ..lineTo(83.0, 85.0)
      ..lineTo(83.0, 91.0)
      ..lineTo(84.0, 93.0)
      ..lineTo(84.0, 93.0)
      ..lineTo(71.0, 105.0)
      ..lineTo(47.0, 104.0)
      ..lineTo(47.0, 129.0)
      ..lineTo(44.0, 129.0)
      ..lineTo(43.0, 124.0)
      ..lineTo(42.0, 124.0)
      ..lineTo(41.0, 117.0)
      ..lineTo(35.0, 113.0)
      ..lineTo(36.0, 111.0)
      ..lineTo(41.0, 111.0)
      ..lineTo(41.0, 108.0)
      ..lineTo(39.0, 106.0)
      ..lineTo(36.0, 106.0)
      ..lineTo(34.0, 104.0)
      ..lineTo(36.0, 103.0)
      ..lineTo(36.0, 101.0)
      ..lineTo(29.0, 100.0)
      ..lineTo(29.0, 98.0)
      ..lineTo(37.0, 99.0)
      ..lineTo(37.0, 97.0)
      ..lineTo(35.0, 94.0)
      ..lineTo(36.0, 83.0)
      ..lineTo(33.0, 82.0)
      ..lineTo(31.0, 78.0)
      ..lineTo(29.0, 73.0)
      ..lineTo(29.0, 69.0)
      ..lineTo(31.0, 69.0)
      ..lineTo(31.0, 67.0)
      ..lineTo(31.0, 63.0)
      ..lineTo(30.0, 60.0)
      ..lineTo(29.0, 55.0)
      ..lineTo(29.0, 52.0)
      ..lineTo(31.0, 52.0)
      ..lineTo(31.0, 47.0)
      ..lineTo(36.0, 44.0)
      ..lineTo(39.0, 41.0)
      ..lineTo(41.0, 36.0)
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = bike.frame;
    canva.drawPath(path, paint);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.25
      ..color = const Color(0xFFC3C3C3);
    canva.drawPath(path, paint);
  }
}
