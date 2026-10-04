import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injectable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('prod');

  runApp(const MyApp());
}
