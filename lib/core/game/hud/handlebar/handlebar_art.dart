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
  static const Color colorC3C3C3 = Color(0xFFC3C3C3);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);
  static const double width = 200.0;
  static const double height = 200.0;
  static const Offset pivot = Offset(111.0, 117.0);
  static const double length = 102.0;
  static const Offset gripCentre = Offset(36.5, 112.5);
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

  /// Draws the complete handlebar.
  void paint(Canvas canvas, {double extension = 0, Color? gripColor}) {
    paintPipe(canvas, extension: extension);
    paintGrip(canvas, color: gripColor ?? color7F7F7F);
  }

  /// Draws only the pipe, allowing it to remain behind the dashboard.
  void paintPipe(Canvas canvas, {double extension = 0}) {
    _drawHandleBarPipe(canvas, extension);
  }

  /// Draws only the grip, allowing it to be layered above the dashboard.
  void paintGrip(Canvas canvas, {Color color = color7F7F7F}) {
    _drawHandleBarGrip(canvas, color);
  }

  /// Shape "HandleBarPipe".
  void _drawHandleBarPipe(Canvas canvas, double extension) {
    _path
      ..reset()
      ..moveTo(10.0, 71.0)
      ..lineTo(81.0, 67.0)
      ..lineTo(93.0, 68.0)
      ..lineTo(102.0, 72.0)
      ..lineTo(113.0, 81.0)
      ..lineTo(119.0, 87.0)
      ..lineTo(126.0, 91.0)
      ..lineTo(177.0, 91.0)
      ..lineTo(186.0, 88.0)
      ..lineTo(194.0, 79.0)
      ..lineTo(203.0, 72.0)
      ..lineTo(212.0, 69.0)
      ..lineTo(222.0, 68.0)
      ..lineTo(291.0, 71.0)
      ..lineTo(291.0, 80.0)
      ..lineTo(221.0, 75.0)
      ..lineTo(212.0, 76.0)
      ..lineTo(205.0, 80.0)
      ..lineTo(198.0, 87.0)
      ..lineTo(190.0, 95.0)
      ..lineTo(179.0, 100.0)
      ..lineTo(124.0, 100.0)
      ..lineTo(117.0, 96.0)
      ..lineTo(110.0, 90.0)
      ..lineTo(103.0, 84.0)
      ..lineTo(93.0, 77.0)
      ..lineTo(80.0, 75.0)
      ..lineTo(10.0, 80.0)
      ..close();
    _paint
      ..style = PaintingStyle.fill
      ..color = colorC3C3C3;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = colorFFFFFF;
    canvas.drawPath(_path, _paint);
  }

  /// Shape "HandleBarGrip".
  void _drawHandleBarGrip(Canvas canvas, Color fill) {
    _paint
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawRect(
      const Rect.fromLTRB(12.0, 49.0, 51.0, 59.0),
      _paint,
    );

    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color000000;
    canvas.drawRect(
      const Rect.fromLTRB(12.0, 49.0, 51.0, 59.0),
      _paint,
    );
  }
}
