// Project imports:
import '../../domain/models/name_status.dart';
import '../../domain/models/player_session.dart';

/// Builds a [PlayerSession] from JSON.
PlayerSession playerSessionFromJson(Map<String, dynamic> json) => PlayerSession(
  token: json['token'] as String,
  playerId: json['player_id'] as String,
  name: json['name'] as String,
  isAdmin: json['is_admin'] == true,
);

/// Converts a [PlayerSession] to JSON.
Map<String, dynamic> playerSessionToJson(PlayerSession session) => {
  'token': session.token,
  'player_id': session.playerId,
  'name': session.name,
  'is_admin': session.isAdmin,
};

/// Builds a [NameStatus] from JSON.
NameStatus nameStatusFromJson(Map<String, dynamic> json) => NameStatus(
  switch (json['status']) {
    'available' => NameCheck.available,
    'taken' => NameCheck.taken,
    'reserved_open' => NameCheck.reservedOpen,
    _ => NameCheck.invalid,
  },
  name: json['name'] as String?,
  question: json['question'] as String?,
);
