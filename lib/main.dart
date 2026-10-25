// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'app.dart';
import 'core/di/injectable.dart';
import 'core/platform/display_setup.dart';
import 'core/supabase/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDisplay();
  await _initSupabase();
  await configureDependencies('prod');

  runApp(const MyApp());
}

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
