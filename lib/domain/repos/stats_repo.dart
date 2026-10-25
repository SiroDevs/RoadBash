// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../common/constants/pref_constants.dart';
import '../../core/supabase/api_client.dart';
import '../../core/utils/uuid.dart';
import '../models/stats_models.dart';
import 'prefs_repo.dart';

@lazySingleton
class StatsRepo {
  StatsRepo(this._api, this._prefs);

  final ApiClient _api;
  final PrefsRepo _prefs;
  Timer? _beat;
  bool _visitLogged = false;

  int get _offset => DateTime.now().timeZoneOffset.inMinutes;

  String get visitorId {
    var id = _prefs.getPrefString(PrefConstants.visitorIdKey);
    if (id.isEmpty) {
      id = newUuidV4();
      _prefs.setPrefString(PrefConstants.visitorIdKey, id);
    }
    return id;
  }

  Future<void> trackVisit() async {
    if (_visitLogged || !_api.isConfigured) return;
    _visitLogged = true;
    try {
      await _api.call('rb_track_visit', {
        'p_visitor': visitorId,
        'p_platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      });
    } catch (_) {}
    _beat ??= Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
  }

  Future<void> _heartbeat() async {
    try {
      await _api.call('rb_heartbeat', {
        'p_visitor': visitorId,
        'p_token': _api.session?.token,
      });
    } catch (_) {}
  }

  Future<int> onlineCount() async {
    final res = await _api.call('rb_online_count');
    return (res['online'] as num).toInt();
  }

  Future<StatsSummary> summary() async => StatsSummary.fromJson(
    await _api.call('rb_stats_summary', {'p_tz_offset': _offset}),
  );

  Future<List<StatsPoint>> series(StatsRange range) async {
    final res = await _api.call('rb_stats_series', {
      'p_days': range.days,
      'p_tz_offset': _offset,
    });
    return [
      for (final p in res['data'] as List)
        StatsPoint.fromJson(Map<String, dynamic>.from(p as Map)),
    ];
  }

  Future<List<HeatCell>> heatmap(StatsRange range) async {
    final res = await _api.call('rb_stats_heatmap', {
      'p_days': range.heatmapDays,
      'p_tz_offset': _offset,
    });
    return [
      for (final c in res['data'] as List)
        HeatCell.fromJson(Map<String, dynamic>.from(c as Map)),
    ];
  }
}
