// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'engine_flavour.dart';

/// Player's name, volumes and control settings.
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
    this.language = '',
  });

  final String name;
  final double master;
  final double music;
  final double engine;
  final double effects;
  final EngineFlavour flavour;

  final bool useScreenTouch;

  final bool mute;
  final bool musicOn;
  final bool effectsOn;
  final bool engineOn;

  final bool invertTilt;
  final String language;

  /// Master volume, zero when muted.
  double get masterGain => mute ? 0.0 : master;
  /// Music volume after master and on/off.
  double get musicGain => musicOn ? masterGain * music : 0.0;
  /// Sound effects volume after master and on/off.
  double get effectsGain => effectsOn ? masterGain * effects : 0.0;
  /// Engine volume after master and on/off.
  double get engineGain => engineOn ? masterGain * engine : 0.0;

  /// Returns a copy with the given fields replaced.
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
    String? language,
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
    language: language ?? this.language,
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
    language,
  ];
}
