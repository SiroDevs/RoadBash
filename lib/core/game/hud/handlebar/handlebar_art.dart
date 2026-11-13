// Dart imports:
import 'dart:ui';

// Project imports:
import 'handlebar_config.dart';

/// Handlebar artwork on a 300 x 200 canvas, drawn as three separate pieces.
/// The pipe and grips are level and straight, and drawn thicker by the
/// amounts in [HandlebarConfig].
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

  /// Centre of each grip's body, and the body's thickness in art units before
  /// [HandlebarConfig.gripThicken] is added.
  static const Offset _rightGripCentreAtScaleOne = Offset(272.0, 72.0);
  static const Offset _leftGripCentreAtScaleOne = Offset(29.0, 72.0);
  static const double gripThickness = 13.0;

  static Offset get rightGripCentre => Offset(
    rightEdge +
        (_rightGripCentreAtScaleOne.dx - rightEdge) *
            HandlebarConfig.gripLengthScale,
    _rightGripCentreAtScaleOne.dy,
  );

  static Offset get leftGripCentre => Offset(
    leftEdge +
        (_leftGripCentreAtScaleOne.dx - leftEdge) *
            HandlebarConfig.gripLengthScale,
    _leftGripCentreAtScaleOne.dy,
  );

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
    canvas.translate(rightEdge, 0);
    canvas.scale(HandlebarConfig.gripLengthScale, 1);
    canvas.translate(-rightEdge, 0);
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
    canvas.translate(leftEdge, 0);
    canvas.scale(HandlebarConfig.gripLengthScale, 1);
    canvas.translate(-leftEdge, 0);
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
      ..moveTo(x(10.0), 68.0)
      ..lineTo(x(81.0), 68.0)
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
      ..lineTo(x(291.0), 68.0)
      ..lineTo(x(291.0), 76.0)
      ..lineTo(x(221.0), 76.0)
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
      ..lineTo(x(80.0), 76.0)
      ..lineTo(x(10.0), 76.0)
      ..close();
    _fillWithRim(canvas, colorC3C3C3, colorFFFFFF, HandlebarConfig.pipeThicken);
  }

  /// Shape "RightHandleGrip": level and straight, with an upright flange.
  void _drawRightHandleGrip(Canvas canvas, Color fill) {
    _path
      ..reset()
      ..moveTo(248.0, 82.0)
      ..lineTo(248.0, 62.0)
      ..lineTo(252.0, 62.0)
      ..lineTo(252.0, 65.5)
      ..lineTo(292.0, 65.5)
      ..lineTo(296.0, 69.0)
      ..lineTo(296.0, 75.0)
      ..lineTo(292.0, 78.5)
      ..lineTo(252.0, 78.5)
      ..lineTo(252.0, 82.0)
      ..close();
    _fillWithRim(canvas, fill, color7F7F7F, HandlebarConfig.gripThicken);
  }

  /// Shape "LeftHandleGrip": the right grip mirrored.
  void _drawLeftHandleGrip(Canvas canvas, Color fill) {
    _path
      ..reset()
      ..moveTo(53.0, 82.0)
      ..lineTo(53.0, 62.0)
      ..lineTo(49.0, 62.0)
      ..lineTo(49.0, 65.5)
      ..lineTo(9.0, 65.5)
      ..lineTo(5.0, 69.0)
      ..lineTo(5.0, 75.0)
      ..lineTo(9.0, 78.5)
      ..lineTo(49.0, 78.5)
      ..lineTo(49.0, 82.0)
      ..close();
    _fillWithRim(canvas, fill, colorC3C3C3, HandlebarConfig.gripThicken);
  }

  /// Fills the current path, thickened by [thicken] units, with a thin rim.
  void _fillWithRim(Canvas canvas, Color fill, Color rim, double thicken) {
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = thicken + 1.0
      ..color = rim;
    canvas.drawPath(_path, _paint);
    _paint
      ..strokeWidth = thicken
      ..color = fill;
    canvas.drawPath(_path, _paint);
    _paint
      ..style = PaintingStyle.fill
      ..color = fill;
    canvas.drawPath(_path, _paint);
  }
}
