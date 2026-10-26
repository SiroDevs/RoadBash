import 'package:injectable/injectable.dart';

import '../../domain/models/suggestion.dart';
import '../../domain/repos/suggestion_repo.dart';
import '../mappers/suggestion_mapper.dart';
import '../sources/remote/api_client.dart';

@LazySingleton(as: SuggestionRepo)
class SuggestionRepoImpl implements SuggestionRepo {
  SuggestionRepoImpl(this._api);

  final ApiClient _api;

  @override
  Future<void> submit(String message) =>
      _api.callAuthed('rb_submit_suggestion', {'p_message': message});

  @override
  Future<List<Suggestion>> inbox() async =>
      (await _api.callAuthed('rb_list_suggestions')).rows(suggestionFromJson);
}
