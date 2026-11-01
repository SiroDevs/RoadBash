// Project imports:
import '../terrain/jungle_zones.dart';
import '../terrain/terrain_zones.dart';
import 'road_track.dart';

/// Lays zones of ground and roadside settings over a built track.
extension RoadTrackZones on RoadTrack {
  /// Lays the ground of each zone over the segments built so far.
  void applyTerrain(List<TerrainZone> zones, int courseEnd) {
    for (final zone in zones) {
      final start = (zone.from * courseEnd).round();
      final end = (zone.to * courseEnd).round();
      for (var index = start; index < end && index < segments.length; index++) {
        final progress = (index - start) / (end - start - 1).clamp(1, 1 << 30);
        segments[index] = segments[index].withGround(zone.groundAt(progress));
      }
    }
  }

  /// Gives each zone's stretch the verges that belong to its setting.
  void applySites(List<JungleZone> zones, int courseEnd) {
    for (final zone in zones) {
      final start = (zone.from * courseEnd).round();
      final end = (zone.to * courseEnd).round();
      for (var index = start; index < end && index < segments.length; index++) {
        segments[index] = segments[index].withSection(zone.site.section);
      }
    }
  }
}
