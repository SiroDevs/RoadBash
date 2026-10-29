// Project imports:
import '../models/suggestion.dart';

/// Contract for sending and reading suggestions.
abstract interface class SuggestionRepo {
  Future<void> submit(String message);
  Future<List<Suggestion>> inbox();
}
