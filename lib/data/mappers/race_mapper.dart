// Project imports:
import '../../domain/models/race_record.dart';
import '../../domain/models/scene_id.dart';

RaceRecord raceRecordFromJson(Map<String, dynamic> row, String playerName) =>
    RaceRecord(
      scene: SceneId.values.asNameMap()[row['scene']] ?? SceneId.city,
      place: (row['place'] as num).toInt(),
      timeMs: (row['time_ms'] as num).toInt(),
      playerName: playerName,
      finishedAt: DateTime.parse(row['finished_at'] as String).toLocal(),
    );
