// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:roadbash/core/audio/audio_service.dart' as _i257;
import 'package:roadbash/core/audio/cubit/audio_cubit.dart' as _i683;
import 'package:roadbash/core/di/injectable.dart' as _i970;
import 'package:roadbash/core/progress/progress_cubit.dart' as _i641;
import 'package:roadbash/core/settings/settings_cubit.dart' as _i550;
import 'package:roadbash/data/app_database.dart' as _i291;
import 'package:roadbash/domain/repos/prefs_repo.dart' as _i805;
import 'package:roadbash/domain/repos/profile_repo.dart' as _i624;
import 'package:roadbash/domain/repos/race_repo.dart' as _i541;
import 'package:roadbash/feature/menu/cubit/menu_cubit.dart' as _i158;
import 'package:roadbash/feature/splash/cubit/splash_cubit.dart' as _i178;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i158.MenuCubit>(() => _i158.MenuCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs(),
      preResolve: true,
    );
    await gh.singletonAsync<_i291.AppDatabase>(
      () => registerModule.appDatabase(),
      preResolve: true,
    );
    gh.lazySingleton<_i257.AudioService>(() => _i257.AudioService());
    gh.lazySingleton<_i624.ProfileRepo>(
      () => _i624.ProfileRepo(gh<_i291.AppDatabase>()),
    );
    gh.lazySingleton<_i541.RaceRepo>(
      () => _i541.RaceRepo(gh<_i291.AppDatabase>()),
    );
    gh.singleton<_i805.PrefsRepo>(
      () => _i805.PrefsRepo(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i550.SettingsCubit>(
      () => _i550.SettingsCubit(gh<_i624.ProfileRepo>()),
    );
    gh.lazySingleton<_i641.ProgressCubit>(
      () => _i641.ProgressCubit(gh<_i541.RaceRepo>()),
    );
    gh.factory<_i178.SplashCubit>(
      () => _i178.SplashCubit(
        gh<_i550.SettingsCubit>(),
        gh<_i641.ProgressCubit>(),
      ),
    );
    gh.lazySingleton<_i683.AudioCubit>(
      () =>
          _i683.AudioCubit(gh<_i257.AudioService>(), gh<_i550.SettingsCubit>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i970.RegisterModule {}
