import '../../domain/models/name_status.dart';
import '../../domain/models/player_session.dart';

PlayerSession playerSessionFromJson(Map<String, dynamic> json) => PlayerSession(
  token: json['token'] as String,
  playerId: json['player_id'] as String,
  name: json['name'] as String,
  isAdmin: json['is_admin'] == true,
);

Map<String, dynamic> playerSessionToJson(PlayerSession s) => {
  'token': s.token,
  'player_id': s.playerId,
  'name': s.name,
  'is_admin': s.isAdmin,
};

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
