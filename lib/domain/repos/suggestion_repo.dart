// Project imports:
import '../models/suggestion.dart';

abstract interface class SuggestionRepo {
  Future<void> submit(String message);
  Future<List<Suggestion>> inbox();
}
