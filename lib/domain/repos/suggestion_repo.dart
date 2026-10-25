// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/supabase/api_client.dart';
import '../models/suggestion.dart';

@lazySingleton
class SuggestionRepo {
  SuggestionRepo(this._api);

  final ApiClient _api;

  Future<void> submit(String message) =>
      _api.callAuthed('rb_submit_suggestion', {'p_message': message});

  Future<List<Suggestion>> inbox() async {
    final res = await _api.callAuthed('rb_list_suggestions');
    return [
      for (final s in res['data'] as List)
        Suggestion.fromJson(Map<String, dynamic>.from(s as Map)),
    ];
  }
}
