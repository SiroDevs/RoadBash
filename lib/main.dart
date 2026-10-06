// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app.dart';
import 'core/di/injectable.dart';
import 'core/platform/display_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDisplay();
  await configureDependencies('prod');

  runApp(const MyApp());
}
