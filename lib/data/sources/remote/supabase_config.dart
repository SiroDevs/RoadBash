// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static String get url => dotenv.maybeGet('SUPABASE_URL')?.trim() ?? '';
  static String get publishableKey => dotenv.maybeGet('SUPABASE_PUBLISHABLE_KEY')?.trim() ?? '';

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  static bool ready = false;
}
