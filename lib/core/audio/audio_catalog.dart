// Project imports:
import '../../domain/models/scene_id.dart';

enum MusicTrack {
  menu('audio/music/menu.wav', 1.0),
  city('audio/music/city.wav', 0.55),
  suburbs('audio/music/suburbs.wav', 0.55);

  const MusicTrack(this.asset, this.gain);

  final String asset;
  final double gain;

  static MusicTrack forScene(SceneId id) => id == SceneId.city ? city : suburbs;
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
  engine,
  skid,
  gravel,
  wind;

  String get asset => 'audio/loops/$name.wav';
}
