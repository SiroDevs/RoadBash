part of '../rider_painter.dart';

class Gloves extends RiderPartPainter {
  Gloves(super.look);

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final foot = pose.foot.clamp(0.0, 1.0);

    double m(double moving, double stopped) => moving + (stopped - moving) * foot;

    path
      ..reset()
      ..moveTo(m(30.6, 27.6), 23.4)
      ..lineTo(m(27, 24), 30.0)
      ..lineTo(m(19, 16), 34.0)
      ..lineTo(m(11, 8), 31.0)
      ..lineTo(m(10, 7), 20.0)
      ..lineTo(m(12, 9), 16.0)
      ..lineTo(m(17, 14), 14.0)
      ..lineTo(m(19.1, 16.6), m(10.2, 9.2))
      ..close();
    paint
      ..style = PaintingStyle.fill
      ..color = look.gloves;
    canva.drawPath(path, paint);

    path
      ..reset()
      ..moveTo(93.0, 31.0)
      ..lineTo(97.0, 38.0)
      ..lineTo(106.0, 38.0)
      ..lineTo(111.0, 35.0)
      ..lineTo(111.0, 26.0)
      ..lineTo(110.0, 22.0)
      ..lineTo(106.0, 22.0)
      ..lineTo(104.0, 15.0)
      ..close();
    canva.drawPath(path, paint);
  }
}
