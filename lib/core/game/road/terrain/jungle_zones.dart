// Project imports:
import '../track/road_section.dart';
import 'terrain.dart';
import 'terrain_zones.dart';

/// A roadside setting along the jungle road.
enum JungleSite {
  mountainRight(Section(left: VergeKind.cliff, right: VergeKind.dirt)),
  mountainLeft(Section(left: VergeKind.dirt, right: VergeKind.ledge)),
  river(Section(left: VergeKind.water, right: VergeKind.water)),
  pass(Section(left: VergeKind.dirt, right: VergeKind.dirt)),
  canopy(Section(left: VergeKind.grass, right: VergeKind.grass));

  const JungleSite(this.section);

  final Section section;
}

/// A stretch of the jungle road with one setting, as fractions of the course.
class JungleZone {
  const JungleZone(this.from, this.to, this.site);

  final double from;
  final double to;
  final JungleSite site;
}

/// Where each setting lies along the jungle road.
const List<JungleZone> jungleZones = [
  JungleZone(0.06, 0.24, JungleSite.mountainRight),
  JungleZone(0.352, 0.381, JungleSite.river),
  JungleZone(0.41, 0.53, JungleSite.canopy),
  JungleZone(0.57, 0.67, JungleSite.pass),
  JungleZone(0.72, 0.90, JungleSite.mountainLeft),
];

/// Where the jungle road loses its tarmac, and where it fords the river.
const List<TerrainZone> jungleTerrain = [
  TerrainZone(0.26, 0.33, Terrain.loose, goodLine: true),
  TerrainZone(0.338, 0.356, Terrain.stony),
  TerrainZone(0.356, 0.377, Terrain.water),
  TerrainZone(0.377, 0.395, Terrain.stony),
  TerrainZone(0.45, 0.50, Terrain.loose, goodLine: true),
  TerrainZone(0.675, 0.715, Terrain.loose, goodLine: true),
];
