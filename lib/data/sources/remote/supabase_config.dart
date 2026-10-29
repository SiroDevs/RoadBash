// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Backend connection settings read from the environment.
class SupabaseConfig {
  SupabaseConfig._();

  /// Backend URL.
  static String get url => dotenv.maybeGet('SUPABASE_URL')?.trim() ?? '';
  /// Backend publishable key.
  static String get publishableKey => dotenv.maybeGet('SUPABASE_PUBLISHABLE_KEY')?.trim() ?? '';

  /// True when both the URL and key are set.
  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  static bool ready = false;
}
