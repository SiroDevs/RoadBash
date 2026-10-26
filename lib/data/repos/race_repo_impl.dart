import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../domain/models/race_record.dart';
import '../../domain/repos/race_repo.dart';
import '../mappers/race_mapper.dart';
import '../sources/remote/api_client.dart';

@LazySingleton(as: RaceRepo)
class RaceRepoImpl implements RaceRepo {
  RaceRepoImpl(this._api);

  final ApiClient _api;
  final List<RaceRecord> _records = [];

  @override
  Future<List<RaceRecord>> all() async {
    final session = _api.session;
    if (session == null) return List.unmodifiable(_records);
    try {
      final res = await _api.callAuthed('rb_my_games');
      _records
        ..clear()
        ..addAll(res.rows((row) => raceRecordFromJson(row, session.name)));
    } catch (_) {}
    return List.unmodifiable(_records);
  }

  @override
  Future<void> add(RaceRecord record) async {
    _records.add(record);
    if (_api.session != null) unawaited(_push(record));
  }

  Future<void> _push(RaceRecord record) async {
    try {
      await _api.callAuthed('rb_record_game', {
        'p_scene': record.scene.name,
        'p_place': record.place,
        'p_time_ms': record.timeMs,
      });
    } catch (_) {}
  }
}
