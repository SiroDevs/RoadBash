// Dart imports:
import 'dart:ui';

// Project imports:
import 'landmarks/landmarks.dart';

const double cityLeft = 12;
const double cityTop = 11;
const double cityBaseline = 90;
const double cityTile = 190;

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
  final scale = height / (cityBaseline - cityTop);
  final tile = cityTile * scale;
  _cityPaint.colorFilter = haze == null
      ? null
      : ColorFilter.mode(haze, BlendMode.srcOver);
  for (var i = (scroll / tile).floor(); i * tile - scroll < width; i++) {
    canva
      ..save()
      ..translate(i * tile - scroll, baseY)
      ..scale(scale)
      ..translate(-cityLeft, -cityBaseline);

    for (final building in nairobiLandmarks) {
      building(canva, _cityPaint);
    }
    canva.restore();
  }
}
