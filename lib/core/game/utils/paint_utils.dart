// Dart imports:
import 'dart:ui';

// Project imports:
import '../road/config/road_config.dart';

/// Creates a fill paint for a color.
Paint fillPaint(Color color, {bool antiAlias = true}) => Paint()
  ..color = color
  ..isAntiAlias = antiAlias;

/// Returns a darker shade of a color.
Color shade(Color color, double amount) => Color.lerp(
  color,
  amount < 0 ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
  amount.abs(),
)!;

/// Builds paints that fade a color into the fog.
List<Paint> fogRamp(Color base, Color fog, {bool antiAlias = false}) =>
    List.generate(RoadConfig.fogSteps, (i) {
      final fraction = i / (RoadConfig.fogSteps - 1);
      return fillPaint(Color.lerp(base, fog, fraction)!, antiAlias: antiAlias);
    });

/// Picks the paint for a fog amount.
Paint fogged(List<Paint> ramp, double fog) {
  final step = (fog * (ramp.length - 1)).round();
  return ramp[step < 0 ? 0 : (step >= ramp.length ? ramp.length - 1 : step)];
}

/// Adds a four-corner shape to a path.
///
/// Takes the four corners as (x1, y1) to (x4, y4), in drawing order.
void addQuad(
  Path path,
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
  double x4,
  double y4,
) {
  path
    ..moveTo(x1, y1)
    ..lineTo(x2, y2)
    ..lineTo(x3, y3)
    ..lineTo(x4, y4)
    ..close();
}

/// Draws a filled four-corner shape.
///
/// Takes the four corners as (x1, y1) to (x4, y4), in drawing order, and fills
/// them with [paint].
void drawQuad(
  Canvas canva,
  Path path,
  Paint paint,
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
  double x4,
  double y4,
) {
  path.reset();
  addQuad(path, x1, y1, x2, y2, x3, y3, x4, y4);
  canva.drawPath(path, paint);
}
