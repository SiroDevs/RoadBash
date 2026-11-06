// Project imports:
import 'scene_id.dart';

/// Scene sets and lap counts shared by the levels.
abstract final class LevelPresets {
  static const Set<SceneId> starter = {SceneId.city, SceneId.suburbs};
  static const Set<SceneId> withThika = {
    SceneId.city,
    SceneId.suburbs,
    SceneId.thikaRoad,
  };
  static const Set<SceneId> everything = {
    SceneId.city,
    SceneId.suburbs,
    SceneId.thikaRoad,
    SceneId.jungle,
    SceneId.dirtRoad,
  };

  static const Map<SceneId, int> twoLaps = {
    SceneId.city: 2,
    SceneId.suburbs: 2,
  };
  static const Map<SceneId, int> threeLaps = {
    SceneId.city: 3,
    SceneId.suburbs: 3,
  };
  static const Map<SceneId, int> fourLaps = {
    SceneId.city: 4,
    SceneId.suburbs: 4,
  };
}
