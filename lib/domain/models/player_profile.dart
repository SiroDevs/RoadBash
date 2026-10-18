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
  });

  final String name;
  final double master;
  final double music;
  final double engine;
  final double effects;
  final EngineFlavour flavour;

  PlayerProfile copyWith({
    String? name,
    double? master,
    double? music,
    double? engine,
    double? effects,
    EngineFlavour? flavour,
  }) =>
      PlayerProfile(
        name: name ?? this.name,
        master: master ?? this.master,
        music: music ?? this.music,
        engine: engine ?? this.engine,
        effects: effects ?? this.effects,
        flavour: flavour ?? this.flavour,
      );

  @override
  List<Object?> get props => [name, master, music, engine, effects, flavour];
}
