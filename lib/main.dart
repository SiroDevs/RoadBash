// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'app.dart';
import 'core/di/injectable.dart';
import 'core/platform/display_setup.dart';
import 'data/sources/remote/supabase_config.dart';

/// App entry point; initializes services, then starts the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDisplay();
  await dotenv.load();
  await _initSupabase();
  await configureDependencies('prod');

  runApp(const MyApp());
}

/// Initializes Supabase when configured; failures are ignored.
Future<void> _initSupabase() async {
  if (!SupabaseConfig.isConfigured) return;
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    SupabaseConfig.ready = true;
  } catch (_) {}
}
