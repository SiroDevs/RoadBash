// Project imports:
part of '../rider_painter.dart';

/// Everything the rider wears: legs, torso, arms and helmet.
class UpperBody extends RiderPartPainter {
  static const _helmetShell = Color(0xFFF2C21C);
  static const _helmetShade = Color(0xFFC79A0F);
  static const _helmetGloss = Color(0x66FFFFFF);

  static const double _mid = RiderPartPainter.midX;

  void paint(Paint paint, Path path, Canvas canva, RiderPose pose) {
    _helmet(canva, pose);
    _torso(paint, path, canva);
    _arms(paint, path, canva);
  }

  void _helmet(Canvas canva, RiderPose pose) {
    final neckY = tuckOf(pose);

    fill(
      canva,
      Rect.fromLTRB(53, neckY - 30, 67, neckY - 20),
      RiderPartPainter.leather,
      5,
    );

    canva.save();
    canva.translate(_mid, neckY);
    canva.rotate(-pose.lean * 0.3);
    canva.translate(-_mid, -neckY);

    final cy = neckY - 45;
    oval(
      canva,
      Rect.fromCenter(center: Offset(_mid, cy), width: 35, height: 38),
      _helmetShell,
    );
    quad(canva, _helmetShade, [
      Offset(_mid - 15, cy + 8),
      Offset(_mid + 15, cy + 8),
      Offset(_mid + 10, cy + 15),
      Offset(_mid - 10, cy + 15),
    ]);
    fill(
      canva,
      Rect.fromLTRB(_mid - 5, cy - 13, _mid + 12, cy - 5),
      _helmetShade,
      5,
    );
    oval(
      canva,
      Rect.fromCenter(center: Offset(_mid - 5, cy - 5), width: 15, height: 11),
      _helmetGloss,
    );
    canva.restore();
  }

  void _torso(Paint paint, Path path, Canvas canva) {
    path
      ..reset()
      ..moveTo(41.0, 35.0)
      ..lineTo(51.0, 30.0)
      ..lineTo(61.0, 29.0)
      ..lineTo(72.0, 32.0)
      ..lineTo(80.0, 36.0)
      ..lineTo(89.0, 22.0)
      ..lineTo(91.0, -25.0)
      ..lineTo(75.0, -32.0)
      ..lineTo(60.0, -34.0)
      ..lineTo(43.0, -33.0)
      ..lineTo(30.0, -27.0)
      ..lineTo(30.0, 23.0)
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

  /// Sleeves and gloves, reaching for the grips [RiderBike] draws over them.
  void _arms(Paint paint, Path path, Canvas canva) {
    // Right Hand
    path
      ..reset()
      ..moveTo(91.0, -24.0)
      ..lineTo(113.0, 20.0)
      ..lineTo(112.0, 30.0)
      ..lineTo(101.0, 35.0)
      ..lineTo(84.0, 11.0)
      ..lineTo(84.0, -10.0)
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
    // Left Hand
    path
      ..reset()
      ..moveTo(30.0, -26.0)
      ..lineTo(9.0, 25.0)
      ..lineTo(13.0, 36.0)
      ..lineTo(25.0, 37.0)
      ..lineTo(37.0, 10.0)
      ..lineTo(37.0, -12.0)
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
