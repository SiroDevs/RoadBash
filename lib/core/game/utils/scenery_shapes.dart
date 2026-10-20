// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import 'nairobi/exports.dart';

const double cityLeft = 12;
const double cityTop = 11;
const double cityBaseline = 90;
const double cityTile = 190;
const Color colorB97A57 = Color(0xFFB97A57);
const Color color3F48CC = Color(0xFF3F48CC);
const Color color00A2E8 = Color(0xFF00A2E8);
const Color color99D9EA = Color(0xFF99D9EA);
const Color colorC8BFE7 = Color(0xFFC8BFE7);
const Color color7092BE = Color(0xFF7092BE);
const Color color7F7F7F = Color(0xFF7F7F7F);
const Color colorC3C3C3 = Color(0xFFC3C3C3);
const Color color000000 = Color(0xFF000000);
const Color colorFF7F27 = Color(0xFFFF7F27);
const Color color880015 = Color(0xFF880015);

typedef CityPart = void Function(Canvas canvas, Paint paint);

final Path path = Path();

void tracePoints(List<double> pts) {
  path
    ..reset()
    ..moveTo(pts[0], pts[1]);
  for (var i = 2; i < pts.length; i += 2) {
    path.lineTo(pts[i], pts[i + 1]);
  }
  path.close();
}

void fillContainer(Canvas canva, Paint paint, Color color) {
  paint
    ..style = PaintingStyle.fill
    ..color = color;
  canva.drawPath(path, paint);
}

void drawEdge(Canvas canva, Paint paint, Color color, [double width = 0.25]) {
  paint
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color;
  canva.drawPath(path, paint);
}

void drawPoly(Canvas canva, Paint paint, List<double> pts, Color color, {Color? edge}) {
  tracePoints(pts);
  fillContainer(canva, paint, color);
  if (edge != null) drawEdge(canva, paint, edge);
}

void drawRect(Canvas canva, Paint paint, Rect r, Color color) {
  path
    ..reset()
    ..addRect(r);
  fillContainer(canva, paint, color);
}

void drawOval(Canvas canva, Paint paint, Rect r, Color color) {
  path
    ..reset()
    ..addOval(r);
  fillContainer(canva, paint, color);
}

void drawLines(Canvas canva, Paint paint, List<double> s, Color color, [double w = 0.25]) {
  path.reset();
  for (var i = 0; i < s.length; i += 4) {
    path
      ..moveTo(s[i], s[i + 1])
      ..lineTo(s[i + 2], s[i + 3]);
  }
  drawEdge(canva, paint, color, w);
}

/// Cheap deterministic pseudo-random number in [0, 1) for [n].
double pseudoRandom(int n) {
  final s = math.sin(n * 12.9898) * 43758.5453;
  return s - s.floorToDouble();
}

final Paint _cityPaint = Paint()
  ..isAntiAlias = true
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void drawCityScape(
  Canvas canva, {
  required double width,
  required double baseY,
  required double height,
  required double scroll,
  Color? haze,
}) {
  final s = height / (cityBaseline - cityTop);
  final tile = cityTile * s;
  _cityPaint.colorFilter = haze == null
      ? null
      : ColorFilter.mode(haze, BlendMode.srcOver);
  for (var i = (scroll / tile).floor(); i * tile - scroll < width; i++) {
    canva
      ..save()
      ..translate(i * tile - scroll, baseY)
      ..scale(s)
      ..translate(-cityLeft, -cityBaseline);
      
    const List<CityPart> cityBuildings = [
      drawTimesTower,
      drawCoopBuilding,
      drawBuilding2,
      drawPolygon56,
      drawBuilding8,
      drawBuilding22,
      drawBuilding5,
      drawPolygon14,
      drawPolygon15,
      drawPolygon16,
      draw88Tower,
      drawPolygon18,
      drawBuilding7,
      drawBuilding6,
      drawBritam,
      drawBuilding62,
      drawBuilding3,
      drawPolygon25,
      drawDomeBuilding,
      drawDomeBuilding1,
      drawBuilding5a,
      drawTimesTower1,
      drawParliament,
      drawTimesTower2,
      drawTimesTower3,
      drawPolygon24Copy,
      drawBuilding4,
      drawImBuilding,
      drawKicc,
      drawParliament2a,
      drawParliament2b,
      drawParliament2c,
      drawKicc2,
    ];

    for (final building in cityBuildings) {
      building(canva, _cityPaint);
    }
    canva.restore();
  }
}

void drawHills(
  Canvas canva,
  Path path, {
  required double width,
  required double baseY,
  required double amplitude,
  required double frequency,
  required double scroll,
  required Paint paint,
}) {
  path
    ..reset()
    ..moveTo(0, baseY + 1);
  for (double x = 0; x <= width + 8; x += 8) {
    final s = x + scroll;
    final wave =
        1 +
        0.5 * math.sin(s * frequency) +
        0.3 * math.sin(s * frequency * 2.7 + 1.3);
    path.lineTo(x, baseY - amplitude * wave);
  }
  path
    ..lineTo(width, baseY + 1)
    ..close();
  canva.drawPath(path, paint);
}
