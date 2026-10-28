import '../route_stretch.dart';
import 'stretches_blue_post_to_kroad.dart';
import 'stretches_garden_city_to_pangani.dart';
import 'stretches_pangani_to_museum.dart';
import 'stretches_kroad_to_ruiru.dart';
import 'stretches_ruiru_to_roysambu.dart';

const List<RouteStretch> thikaRoute = [
  ...bluePostToKroad,
  ...kRoadToRuiru,
  ...ruiruToRoysambu,
  ...gardenCityToPangani,
  ...panganiToMuseum,
];
