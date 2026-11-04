// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Handlebar artwork on a 300 x 200 canvas, drawn as three separate pieces.
///
/// The pipe is one shape that runs behind the dashboard. The right and left
/// grips are painted on their own so they can be layered above everything.
/// Every piece takes an `extension` in art units: the pipe is stretched about
/// its middle and the grips slide outwards with its ends, so the grips keep
/// their size on wide screens.
class HandlebarArt {
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();

  static const Color colorC3C3C3 = Color(0xFFC3C3C3);
  static const Color colorFFFFFF = Color(0xFFFFFFFF);
  static const Color color000000 = Color(0xFF000000);
  static const Color color7F7F7F = Color(0xFF7F7F7F);
  static const double width = 300.0;
  static const double height = 200.0;

  /// Point the whole handlebar turns about: the middle of the pipe's dip.
  static const Offset pivot = Offset(150.5, 95.5);

  /// Leftmost and rightmost art x of the grips, and the width between them.
  static const double leftEdge = 5.0;
  static const double rightEdge = 296.0;
  static const double span = rightEdge - leftEdge;

  /// Centre of each grip's body, and the body's thickness in art units.
  static const Offset rightGripCentre = Offset(270.0, 74.5);
  static const Offset leftGripCentre = Offset(31.0, 74.5);
  static const double gripThickness = 13.0;

  /// How far each grip is turned in the artwork (it is drawn in perspective).
  static final double rightGripTilt = math.atan2(2.0, 38.0);
  static final double leftGripTilt = -rightGripTilt;

  // The pipe's outer rods are stretched; everything between them stays put.
  static const double _leftRodEnd = 81.0;
  static const double _rightRodStart = 221.0;

  /// Draws the whole handlebar: pipe first, then both grips.
  void paint(Canvas canvas, {double extension = 0}) {
    paintPipe(canvas, extension: extension);
    paintRightGrip(canvas, extension: extension);
    paintLeftGrip(canvas, extension: extension);
  }

  /// Draws only the pipe, so it can stay behind the dashboard.
  void paintPipe(Canvas canvas, {double extension = 0}) {
    _drawHandlebarPipe(canvas, extension);
  }

  /// Draws only the right grip, so it can sit above everything.
  void paintRightGrip(
    Canvas canvas, {
    double extension = 0,
    Color fill = color000000,
  }) {
    canvas.save();
    canvas.translate(extension / 2, 0);
    _drawRightHandleGrip(canvas, fill);
    canvas.restore();
  }

  /// Draws only the left grip, so it can sit above everything.
  void paintLeftGrip(
    Canvas canvas, {
    double extension = 0,
    Color fill = color000000,
  }) {
    canvas.save();
    canvas.translate(-extension / 2, 0);
    _drawLeftHandleGrip(canvas, fill);
    canvas.restore();
  }

  /// Shape "HandlebarPipe".
  void _drawHandlebarPipe(Canvas canvas, double extension) {
    final half = extension / 2;
    double x(double v) => v <= _leftRodEnd
        ? v - half
        : v >= _rightRodStart
            ? v + half
            : v;
    _path
      ..reset()
      ..moveTo(x(10.0), 71.0)
      ..lineTo(x(81.0), 67.0)
      ..lineTo(x(93.0), 68.0)
      ..lineTo(x(102.0), 72.0)
      ..lineTo(x(113.0), 81.0)
      ..lineTo(x(119.0), 87.0)
      ..lineTo(x(126.0), 91.0)
      ..lineTo(x(177.0), 91.0)
      ..lineTo(x(186.0), 88.0)
      ..lineTo(x(194.0), 79.0)
      ..lineTo(x(203.0), 72.0)
      ..lineTo(x(212.0), 69.0)
      ..lineTo(x(222.0), 68.0)
      ..lineTo(x(291.0), 71.0)
      ..lineTo(x(291.0), 80.0)
      ..lineTo(x(221.0), 75.0)
      ..lineTo(x(212.0), 76.0)
      ..lineTo(x(205.0), 80.0)
      ..lineTo(x(198.0), 87.0)
      ..lineTo(x(190.0), 95.0)
      ..lineTo(x(179.0), 100.0)
      ..lineTo(x(124.0), 100.0)
      ..lineTo(x(117.0), 96.0)
      ..lineTo(x(110.0), 90.0)
      ..lineTo(x(103.0), 84.0)
      ..lineTo(x(93.0), 77.0)
      ..lineTo(x(80.0), 75.0)
      ..lineTo(x(10.0), 80.0)
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

  /// Shape "RightHandleGrip".
  void _drawRightHandleGrip(Canvas canvas, Color fill) {
    _path
      ..reset()
      ..moveTo(248.0, 84.0)
      ..lineTo(248.0, 64.0)
      ..lineTo(251.0, 67.0)
      ..lineTo(289.0, 69.0)
      ..lineTo(292.0, 67.0)
      ..lineTo(296.0, 71.0)
      ..lineTo(296.0, 80.0)
      ..lineTo(291.0, 85.0)
      ..lineTo(289.0, 82.0)
      ..lineTo(251.0, 80.0)
      ..close();
    _paint
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = color7F7F7F;
    canvas.drawPath(_path, _paint);
  }

  /// Shape "LeftHandleGrip".
  void _drawLeftHandleGrip(Canvas canvas, Color fill) {
    _path
      ..reset()
      ..moveTo(54.0, 84.0)
      ..lineTo(54.0, 64.0)
      ..lineTo(50.0, 67.0)
      ..lineTo(12.0, 69.0)
      ..lineTo(10.0, 67.0)
      ..lineTo(5.0, 70.0)
      ..lineTo(5.0, 80.0)
      ..lineTo(11.0, 84.0)
      ..lineTo(13.0, 82.0)
      ..lineTo(51.0, 80.0)
      ..close();
    _paint
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = colorC3C3C3;
    canvas.drawPath(_path, _paint);
  }
}