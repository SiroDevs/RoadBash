// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../data/app_database.dart';
import '../../data/entities/race_record_entity.dart';
import '../models/race_record.dart';
import '../models/scene_id.dart';

@lazySingleton
class RaceRepo {
  RaceRepo(this._db);

  final AppDatabase _db;

  Future<List<RaceRecord>> all() async {
    final scenes = SceneId.values.asNameMap();
    return [
      for (final e in await _db.raceRecordDao.all())
        RaceRecord(
          scene: scenes[e.scene] ?? SceneId.city,
          place: e.place,
          timeMs: e.timeMs,
          playerName: e.playerName,
          finishedAt: DateTime.fromMillisecondsSinceEpoch(e.finishedAt),
        ),
    ];
  }

  Future<void> add(RaceRecord r) => _db.raceRecordDao.add(RaceRecordEntity(
        null,
        r.scene.name,
        r.place,
        r.timeMs,
        r.playerName,
        r.finishedAt.millisecondsSinceEpoch,
      ));
}
