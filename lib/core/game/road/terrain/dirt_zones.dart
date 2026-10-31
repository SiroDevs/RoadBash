// Project imports:
import 'terrain.dart';
import 'terrain_zones.dart';

/// Where the dirt road turns loose, stony, potholed or muddy.
const List<TerrainZone> dirtZones = [
  TerrainZone(0.06, 0.13, Terrain.loose),
  TerrainZone(0.15, 0.162, Terrain.muddy, center: -0.25, half: 0.55),
  TerrainZone(0.19, 0.27, Terrain.stony),
  TerrainZone(0.29, 0.315, Terrain.potholed, center: 0.3, half: 0.4),
  TerrainZone(0.34, 0.37, Terrain.potholed, center: -0.35, half: 0.4),
  TerrainZone(0.40, 0.50, Terrain.loose),
  TerrainZone(0.52, 0.538, Terrain.muddy, center: 0.3, half: 0.5),
  TerrainZone(0.56, 0.60, Terrain.stony),
  TerrainZone(0.63, 0.655, Terrain.potholed, center: 0.0, half: 0.45),
  TerrainZone(0.68, 0.76, Terrain.loose),
  TerrainZone(0.78, 0.796, Terrain.muddy, center: -0.3, half: 0.5),
  TerrainZone(0.82, 0.86, Terrain.stony),
  TerrainZone(0.875, 0.895, Terrain.potholed, center: -0.2, half: 0.4),
];
