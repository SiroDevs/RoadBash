// Dart imports:
import 'dart:ui';

// Project imports:
import 'britam.dart';
import 'building_1.dart';
import 'building_2.dart';
import 'building_3.dart';
import 'cbd_buildings.dart';
import 'coop_building.dart';
import 'dome_building.dart';
import 'im_building.dart';
import 'kicc.dart';
import 'other_buildings.dart';
import 'parliament.dart';
import 'times_tower.dart';
import 'tower_88.dart';

typedef CityPart = void Function(Canvas canvas, Paint paint);

const List<CityPart> nairobiLandmarks = [
  drawCbdBuildings,
  drawOtherBuildings,
  drawCoopBuilding,
  drawDomeBuilding,
  draw88Tower,
  drawBuilding1,
  drawBuilding2,
  drawTimesTower,
  drawBritam,
  drawParliament,
  drawImBuilding,
  drawBuilding3,
  drawKicc,
];
