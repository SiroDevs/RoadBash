// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../domain/models/race_record.dart';
import '../../../domain/models/scene_id.dart';

class SceneStats {
  const SceneStats({this.races = 0, this.wins = 0, this.bestMs});

  final int races;
  final int wins;
  final int? bestMs;
}

class ProgressState extends Equatable {
  const ProgressState({this.records = const [], this.loaded = false});

  final List<RaceRecord> records;
  final bool loaded;

  /// Stats for one scene, or for every scene when [scene] is null.
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

  int get level => 1 + statsFor(null).wins ~/ 2;

  @override
  List<Object?> get props => [records, loaded];
}
