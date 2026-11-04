// Dart imports:
import 'dart:ui';

/// One-sided handlebar artwork on a 200 x 200 canvas, drawn as the left bar.
class HandlebarArt {
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();

  static const Color color000000 = Color(0xFF000000);
  static const Color color7F7F7F = Color(0xFF7F7F7F);
  static const double width = 200.0;
  static const double height = 200.0;
  static const Offset pivot = Offset(111.0, 117.0);
  static const double length = 102.0;
  static const double belowPivot = 4.0;
  static const Offset gripTopLeft = Offset(13.0, 110.0);
  static const Offset gripBottomLeft = Offset(15.0, 121.0);
  static const Offset gripTopRight = Offset(58.0, 104.0);
  static const Offset gripBottomRight = Offset(60.0, 115.0);
  static const int ridgeCount = 4;
  static const double ridgeStart = 0.08;
  static const double ridgeEnd = 0.92;

  void paint(Canvas canvas) {
    _drawHandleBarPipe(canvas);
    _drawHandleBarGrip(canvas);
    _drawGripRidges(canvas);
  }

  /// Shape "HandleBarPipe".
  void _drawHandleBarPipe(Canvas canvas) {
    _path
      ..reset()
      ..moveTo(10.0, 120.0)
      ..lineTo(80.0, 110.0)
      ..lineTo(110.0, 120.0)
      ..lineTo(112.0, 114.0)
      ..lineTo(80.0, 103.0)
      ..lineTo(9.0, 113.0)
      ..close();
    _paint
      ..style = PaintingStyle.fill
      ..color = color000000;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color000000;
    canvas.drawPath(_path, _paint);
  }

  /// Shape "HandleBarGrip".
  void _drawHandleBarGrip(Canvas canvas) {
    _path
      ..reset()
      ..moveTo(gripTopLeft.dx, gripTopLeft.dy)
      ..lineTo(gripBottomLeft.dx, gripBottomLeft.dy)
      ..lineTo(gripBottomRight.dx, gripBottomRight.dy)
      ..lineTo(gripTopRight.dx, gripTopRight.dy)
      ..close();
    _paint
      ..style = PaintingStyle.fill
      ..color = color7F7F7F;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = color000000;
    canvas.drawPath(_path, _paint);
  }

  /// Draws evenly spaced ridges parallel to the grip's long edges.
  void _drawGripRidges(Canvas canvas) {
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color000000;
    final across = gripBottomLeft - gripTopLeft;
    final along = gripTopRight - gripTopLeft;
    for (var ridge = 1; ridge <= ridgeCount; ridge++) {
      final base = gripTopLeft + across * (ridge / (ridgeCount + 1));
      canvas.drawLine(
        base + along * ridgeStart,
        base + along * ridgeEnd,
        _paint,
      );
    }
  }
}