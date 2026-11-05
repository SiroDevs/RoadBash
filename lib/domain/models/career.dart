// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'level_rules.dart';
import 'scene_id.dart';

/// The player's progress through the levels, saved between sessions.
class Career extends Equatable {
  const Career({this.level = 1, this.streak = 0, this.bests = const {}});

  /// Version of the saved career. A career saved under another version is
  /// dropped and the player starts again from level 1, so raising this number
  /// in a release resets everyone's level, streak and best times.
  static const int epoch = 1;

  /// The level the player races at now.
  final int level;

  /// Wins in a row at [level]; a loss or a crash starts it again from zero.
  final int streak;

  /// Best finish time in milliseconds for each level and scene.
  final Map<String, int> bests;

  /// The rules of the current level.
  LevelRules get rules => LevelRules.of(level);

  /// True when the player is at the top level.
  bool get atTop => level >= LevelRules.top;

  /// Returns the storage key of a level and scene pairing.
  static String key(int level, SceneId scene) => '$level:${scene.name}';

  /// Returns the best time for [scene] at [level], or null if none yet.
  int? bestFor(int level, SceneId scene) => bests[key(level, scene)];

  Career copyWith({int? level, int? streak, Map<String, int>? bests}) => Career(
    level: level ?? this.level,
    streak: streak ?? this.streak,
    bests: bests ?? this.bests,
  );

  /// Encodes the career for local storage.
  String encode() => jsonEncode({
    'epoch': epoch,
    'level': level,
    'streak': streak,
    'bests': bests,
  });

  /// Decodes a stored career, giving a fresh one when the text is unusable or
  /// was saved under another [epoch].
  static Career decode(String text) {
    if (text.isEmpty) return const Career();
    try {
      final data = jsonDecode(text) as Map<String, dynamic>;
      if (data['epoch'] != epoch) return const Career();
      final bests = (data['bests'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      );
      return Career(
        level: ((data['level'] as num?)?.toInt() ?? 1)
            .clamp(1, LevelRules.top)
            .toInt(),
        streak: ((data['streak'] as num?)?.toInt() ?? 0).clamp(0, 999).toInt(),
        bests: bests,
      );
    } catch (_) {
      return const Career();
    }
  }

  @override
  List<Object?> get props => [level, streak, bests];
}