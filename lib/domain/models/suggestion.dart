class Suggestion {
  const Suggestion({
    required this.id,
    required this.playerName,
    required this.message,
    required this.createdAt,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    id: (json['id'] as num).toInt(),
    playerName: json['player_name'] as String,
    message: json['message'] as String,
    createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
  );

  final int id;
  final String playerName;
  final String message;
  final DateTime createdAt;
}
