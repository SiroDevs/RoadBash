class Suggestion {
  const Suggestion({
    required this.id,
    required this.playerName,
    required this.message,
    required this.createdAt,
  });

  final int id;
  final String playerName;
  final String message;
  final DateTime createdAt;
}
