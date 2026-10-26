// Package imports:
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../utils/app_util.dart';
import 'injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'initGetIt', generateForDir: ['lib'])
Future<void> configureDependencies(String environment) async {
  logger('Using environment: $environment');
  await getIt.initGetIt(environment: environment);
  await getIt.allReady();
}

@module
abstract class RegisterModule {
  @singleton
  @preResolve
  Future<SharedPreferences> sharedPrefs() => SharedPreferences.getInstance();
}
