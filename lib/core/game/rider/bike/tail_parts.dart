// Project imports:
part of '../rider_painter.dart';

class TailParts extends RiderPartPainter {
  TailParts(super.look);

  late final TailCovers _covers = TailCovers(look);

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    final tail = tailLift(pose);
    _tailUnit(paint, path, canva, pose, tail);
    _covers.paint(paint, path, canva, pose, tail);
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
