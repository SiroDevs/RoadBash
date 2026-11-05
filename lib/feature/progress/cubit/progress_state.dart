part of 'progress_cubit.dart';

/// Race count, wins and best time for a scene.
class SceneStats {
  const SceneStats({this.races = 0, this.wins = 0, this.bestMs});

  final int races;
  final int wins;
  final int? bestMs;
}

/// All race records, the player's career and a helper to summarize them.
class ProgressState extends Equatable {
  const ProgressState({
    this.records = const [],
    this.career = const Career(),
    this.loaded = false,
  });

  final List<RaceRecord> records;

  /// Level, win streak and best times per level.
  final Career career;
  final bool loaded;

  ProgressState copyWith({List<RaceRecord>? records, Career? career}) =>
      ProgressState(
        records: records ?? this.records,
        career: career ?? this.career,
        loaded: loaded,
      );

  /// Returns race stats for a scene, or all scenes when null.
  SceneStats statsFor(SceneId? scene) {
    final mine = records.where((r) => scene == null || r.scene == scene);
    final wins = mine.where((r) => r.isWin).length;
    final times = mine.map((r) => r.timeMs);
    return SceneStats(
      races: mine.length,
      wins: wins,
      bestMs: times.isEmpty ? null : times.reduce((a, b) => a < b ? a : b),
    );
  }

  /// The player's level, which rises with wins in a row.
  int get level => career.level;

  @override
  List<Object?> get props => [records, career, loaded];
}
