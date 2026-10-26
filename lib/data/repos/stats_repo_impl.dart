import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/uuid.dart';
import '../../domain/models/stats_models.dart';
import '../../domain/repos/stats_repo.dart';
import '../mappers/stats_mapper.dart';
import '../sources/local/pref_keys.dart';
import '../sources/local/prefs_source.dart';
import '../sources/remote/api_client.dart';

@LazySingleton(as: StatsRepo)
class StatsRepoImpl implements StatsRepo {
  StatsRepoImpl(this._api, this._prefs);

  final ApiClient _api;
  final PrefsSource _prefs;
  Timer? _beat;
  bool _visitLogged = false;

  int get _offset => DateTime.now().timeZoneOffset.inMinutes;

  String get _visitorId {
    var id = _prefs.getString(PrefKeys.visitorId);
    if (id.isEmpty) {
      id = newUuidV4();
      _prefs.setString(PrefKeys.visitorId, id);
    }
    return id;
  }

  @override
  Future<void> trackVisit() async {
    if (_visitLogged || !_api.isConfigured) return;
    _visitLogged = true;
    try {
      await _api.call('rb_track_visit', {
        'p_visitor': _visitorId,
        'p_platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      });
    } catch (_) {}
    _beat ??= Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
  }

  Future<void> _heartbeat() async {
    try {
      await _api.call('rb_heartbeat', {
        'p_visitor': _visitorId,
        'p_token': _api.session?.token,
      });
    } catch (_) {}
  }

  @override
  Future<int> onlineCount() async =>
      ((await _api.call('rb_online_count'))['online'] as num).toInt();

  @override
  Future<StatsSummary> summary() async => statsSummaryFromJson(
    await _api.call('rb_stats_summary', {'p_tz_offset': _offset}),
  );

  @override
  Future<List<StatsPoint>> series(StatsRange range) async =>
      (await _api.call('rb_stats_series', {
        'p_days': range.days,
        'p_tz_offset': _offset,
      })).rows(statsPointFromJson);

  @override
  Future<List<HeatCell>> heatmap(StatsRange range) async =>
      (await _api.call('rb_stats_heatmap', {
        'p_days': range.heatmapDays,
        'p_tz_offset': _offset,
      })).rows(heatCellFromJson);
}
