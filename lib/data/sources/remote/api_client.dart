// Dart imports:
import 'dart:async';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../../../domain/errors/api_exception.dart';
import '../../../domain/models/player_session.dart';
import 'supabase_config.dart';

/// Calls backend functions and publishes session changes.
@lazySingleton
class ApiClient {
  ApiClient() : _client = SupabaseConfig.ready ? Supabase.instance.client : null;

  final SupabaseClient? _client;
  final _changes = StreamController<PlayerSession?>.broadcast();

  PlayerSession? session;

  /// True when the backend is configured.
  bool get isConfigured => _client != null;

  /// Emits the current player session whenever it changes.
  Stream<PlayerSession?> get sessionChanges => _changes.stream;

  /// Stores the session and notifies listeners.
  void setSession(PlayerSession? value) {
    session = value;
    _changes.add(value);
  }

  /// Calls a public backend function and returns its result.
  Future<Map<String, dynamic>> call(
    String fn, [
    Map<String, dynamic>? params,
  ]) async {
    final client = _client;
    if (client == null) throw const ApiException('not_configured');
    final Object? raw;
    try {
      raw = await client.rpc(fn, params: params);
    } on PostgrestException {
      throw const ApiException('server');
    } catch (_) {
      throw const ApiException('network');
    }
    if (raw is! Map) throw const ApiException('server');
    final map = Map<String, dynamic>.from(raw);
    if (map['ok'] != true) {
      throw ApiException(
        map['error'] as String? ?? 'server',
        retryAfter: (map['retry_after'] as num?)?.toInt(),
        remaining: (map['remaining'] as num?)?.toInt(),
      );
    }
    return map;
  }

  /// Calls a backend function with the player's session token.
  Future<Map<String, dynamic>> callAuthed(
    String fn, [
    Map<String, dynamic>? params,
  ]) async {
    final current = session;
    if (current == null) throw const ApiException('invalid_session');
    try {
      return await call(fn, {...?params, 'p_token': current.token});
    } on ApiException catch (e) {
      if (e.code == 'invalid_session') setSession(null);
      rethrow;
    }
  }
}

/// Reads rows from a backend result.
extension ApiRows on Map<String, dynamic> {
  /// Parses each row of the result with [parse].
  List<T> rows<T>(T Function(Map<String, dynamic> row) parse) => [
    for (final e in this['data'] as List) parse(Map<String, dynamic>.from(e as Map)),
  ];
}
