// Package imports:
import 'package:equatable/equatable.dart';

/// A signed-in player's token, id and name.
class PlayerSession extends Equatable {
  const PlayerSession({
    required this.token,
    required this.playerId,
    required this.name,
    required this.isAdmin,
  });

  final String token;
  final String playerId;
  final String name;
  final bool isAdmin;

  @override
  List<Object?> get props => [token, playerId, name, isAdmin];
}
