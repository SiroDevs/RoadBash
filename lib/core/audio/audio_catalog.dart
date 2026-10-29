// Project imports:
import '../../domain/models/scene_id.dart';

/// Music tracks and their volume gains.
enum MusicTrack {
  menu('audio/music/menu.mp3', 1.0),
  city('audio/music/city.mp3', 0.6),
  suburbs('audio/music/suburbs.mp3', 0.6),
  thikard('audio/music/thikard.mp3', 0.6);

  const MusicTrack(this.asset, this.gain);

  final String asset;
  final double gain;

  /// Returns the music track of a scene.
  static MusicTrack forScene(SceneId id) => switch (id) {
    SceneId.city => city,
    SceneId.suburbs => suburbs,
    SceneId.thikaRoad => thikard,
    // No dedicated tracks yet: reuse existing ones. Add jungle.mp3 /
    // dirt_road.mp3 to MusicTrack and point these two at them.
    SceneId.jungle => suburbs,
    SceneId.dirtRoad => city,
  };
}

/// Short sound effects.
enum Sfx {
  click,
  beep,
  go,
  shift,
  finish,
  foot;

  /// Returns the asset path of the sound effect.
  String get asset => 'audio/sfx/$name.wav';
}

/// Looping sounds heard during a race.
enum LoopSound {
  skid,
  gravel,
  wind;

  /// Returns the asset path of the loop sound.
  String get asset => 'audio/loops/$name.wav';
}
