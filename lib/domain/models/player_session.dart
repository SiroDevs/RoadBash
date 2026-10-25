// Package imports:
import 'package:equatable/equatable.dart';

class PlayerSession extends Equatable {
  const PlayerSession({
    required this.token,
    required this.playerId,
    required this.name,
    required this.isAdmin,
  });

  factory PlayerSession.fromJson(Map<String, dynamic> json) => PlayerSession(
    token: json['token'] as String,
    playerId: json['player_id'] as String,
    name: json['name'] as String,
    isAdmin: json['is_admin'] == true,
  );

  final String token;
  final String playerId;
  final String name;
  final bool isAdmin;

  @override
  List<Object?> get props => [token, playerId, name, isAdmin];
}
