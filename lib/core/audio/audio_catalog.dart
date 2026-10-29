// Project imports:
import '../../domain/models/scene_id.dart';

enum MusicTrack {
  menu('audio/music/menu.mp3', 1.0),
  city('audio/music/city.mp3', 0.6),
  suburbs('audio/music/suburbs.mp3', 0.6),
  thikard('audio/music/thikard.mp3', 0.6);

  const MusicTrack(this.asset, this.gain);

  final String asset;
  final double gain;

  static MusicTrack forScene(SceneId id) => switch (id) {
    SceneId.city => city,
    SceneId.suburbs => suburbs,
    SceneId.thikaRoad => thikard,
    SceneId.jungle => suburbs,
    SceneId.dirtRoad => city,
  };
}

enum Sfx {
  click,
  beep,
  go,
  shift,
  finish,
  foot;

  String get asset => 'audio/sfx/$name.wav';
}

enum LoopSound {
  skid,
  gravel,
  wind;

  String get asset => 'audio/loops/$name.wav';
}
