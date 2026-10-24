// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'engine_flavour.dart';

class PlayerProfile extends Equatable {
  const PlayerProfile({
    this.name = '',
    this.master = 1.0,
    this.music = 0.7,
    this.engine = 0.8,
    this.effects = 0.8,
    this.flavour = EngineFlavour.classic,
    this.useScreenTouch = false,
    this.mute = false,
    this.musicOn = true,
    this.effectsOn = true,
    this.engineOn = true,
    this.invertTilt = false,
  });

  final String name;
  final double master;
  final double music;
  final double engine;
  final double effects;
  final EngineFlavour flavour;

  /// Phones and tablets: steer with on-screen arrows instead of tilting.
  final bool useScreenTouch;

  /// Silences everything, whatever the other sound options say.
  final bool mute;
  final bool musicOn;
  final bool effectsOn;
  final bool engineOn;

  /// Flips the tilt direction, in case a device reports it the other way round.
  final bool invertTilt;

  /// Volumes after the switches are applied. Use these for playback; the plain
  /// [master], [music], [engine] and [effects] are the slider positions.
  double get masterGain => mute ? 0.0 : master;
  double get musicGain => musicOn ? masterGain * music : 0.0;
  double get effectsGain => effectsOn ? masterGain * effects : 0.0;
  double get engineGain => engineOn ? masterGain * engine : 0.0;

  PlayerProfile copyWith({
    String? name,
    double? master,
    double? music,
    double? engine,
    double? effects,
    EngineFlavour? flavour,
    bool? useScreenTouch,
    bool? mute,
    bool? musicOn,
    bool? effectsOn,
    bool? engineOn,
    bool? invertTilt,
  }) => PlayerProfile(
    name: name ?? this.name,
    master: master ?? this.master,
    music: music ?? this.music,
    engine: engine ?? this.engine,
    effects: effects ?? this.effects,
    flavour: flavour ?? this.flavour,
    useScreenTouch: useScreenTouch ?? this.useScreenTouch,
    mute: mute ?? this.mute,
    musicOn: musicOn ?? this.musicOn,
    effectsOn: effectsOn ?? this.effectsOn,
    engineOn: engineOn ?? this.engineOn,
    invertTilt: invertTilt ?? this.invertTilt,
  );

  @override
  List<Object?> get props => [
    name,
    master,
    music,
    engine,
    effects,
    flavour,
    useScreenTouch,
    mute,
    musicOn,
    effectsOn,
    engineOn,
    invertTilt,
  ];
}
