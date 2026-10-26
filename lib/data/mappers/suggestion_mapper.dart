import '../../domain/models/suggestion.dart';

Suggestion suggestionFromJson(Map<String, dynamic> json) => Suggestion(
  id: (json['id'] as num).toInt(),
  playerName: json['player_name'] as String,
  message: json['message'] as String,
  createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
);
