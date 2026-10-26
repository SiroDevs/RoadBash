import '../route_stretch.dart';
import 'stretches_blue_post_to_kenyatta.dart';
import 'stretches_garden_city_to_museum_hill.dart';
import 'stretches_kenyatta_to_kwa_kairu.dart';
import 'stretches_ruiru_to_roysambu.dart';

const List<RouteStretch> thikaRoute = [
  ...bluePostToKenyatta,
  ...kenyattaToKwaKairu,
  ...ruiruToRoysambu,
  ...gardenCityToMuseumHill,
];
