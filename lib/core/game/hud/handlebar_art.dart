// Dart imports:
import 'dart:math' as math;
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
  static const Offset gripCentre = Offset(36.5, 53.5);
  static const double gripThickness = 11.0;
  static const Offset gripTopLeft = Offset(13.0, 110.0);
  static const Offset gripBottomLeft = Offset(15.0, 121.0);
  static const Offset gripTopRight = Offset(58.0, 104.0);
  static const Offset gripBottomRight = Offset(60.0, 115.0);

  static final double gripTilt = math.atan2(
    gripTopLeft.dy - gripTopRight.dy,
    gripTopRight.dx - gripTopLeft.dx,
  );

  /// The pivot when the pipe is made [extension] art units longer.
  static Offset pivotFor(double extension) =>
      Offset(pivot.dx + extension, pivot.dy);

  /// Draws the bar with the pipe [extension] units longer and the grip in [gripColor].
  void paint(Canvas canvas, {double extension = 0, Color? gripColor}) {
    _drawHandleBarPipe(canvas, extension);
    _drawHandleBarGrip(canvas, gripColor ?? color7F7F7F);
  }

  /// Shape "HandleBarPipe".
  void _drawHandleBarPipe(Canvas canvas, double extension) {
    _path
      ..reset()
      ..moveTo(10.0, 51.0)
      ..lineTo(66.0, 51.0)
      ..lineTo(74.0, 52.0)
      ..lineTo(84.0, 56.0)
      ..lineTo(130.0, 93.0)
      ..lineTo(130.0, 100.0)
      ..lineTo(84.0, 62.0)
      ..lineTo(74.0, 58.0)
      ..lineTo(66.0, 57.0)
      ..lineTo(10.0, 57.0)
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
  void _drawHandleBarGrip(Canvas canvas, Color fill) {
    _paint
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawRect(const Rect.fromLTRB(12.0, 49.0, 51.0, 59.0), _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color000000;
    canvas.drawRect(const Rect.fromLTRB(12.0, 49.0, 51.0, 59.0), _paint);
  }
}
