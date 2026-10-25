// Dart imports:
import 'dart:async';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/supabase/api_client.dart';
import '../models/race_record.dart';
import '../models/scene_id.dart';

@lazySingleton
class RaceRepo {
  RaceRepo(this._api);

  final ApiClient _api;
  final List<RaceRecord> _records = [];

  Future<List<RaceRecord>> all() async {
    final session = _api.session;
    if (session == null) return List.unmodifiable(_records);
    try {
      final res = await _api.callAuthed('rb_my_games');
      _records
        ..clear()
        ..addAll([
          for (final g in res['data'] as List)
            _fromRow(Map<String, dynamic>.from(g as Map), session.name),
        ]);
    } catch (_) {}
    return List.unmodifiable(_records);
  }

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

  RaceRecord _fromRow(Map<String, dynamic> row, String name) => RaceRecord(
    scene: SceneId.values.asNameMap()[row['scene']] ?? SceneId.city,
    place: (row['place'] as num).toInt(),
    timeMs: (row['time_ms'] as num).toInt(),
    playerName: name,
    finishedAt: DateTime.parse(row['finished_at'] as String).toLocal(),
  );
}
