// Package imports:
import 'package:equatable/equatable.dart';

class PlayerProfile extends Equatable {
  const PlayerProfile({
    this.name = '',
    this.master = 1.0,
    this.music = 0.7,
    this.engine = 0.8,
    this.effects = 0.8,
  });

  final String name;
  final double master;
  final double music;
  final double engine;
  final double effects;

  PlayerProfile copyWith({
    String? name,
    double? master,
    double? music,
    double? engine,
    double? effects,
  }) =>
      PlayerProfile(
        name: name ?? this.name,
        master: master ?? this.master,
        music: music ?? this.music,
        engine: engine ?? this.engine,
        effects: effects ?? this.effects,
      );

  @override
  List<Object?> get props => [name, master, music, engine, effects];
}
