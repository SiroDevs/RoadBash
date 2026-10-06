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
import 'package:roadbash/core/di/injectable.dart' as _i970;
import 'package:roadbash/data/local/app_database.dart' as _i686;
import 'package:roadbash/domain/repos/profile_repo.dart' as _i624;
import 'package:roadbash/domain/repos/race_repo.dart' as _i541;
import 'package:roadbash/features/audio/audio_service.dart' as _i1063;
import 'package:roadbash/features/audio/cubit/audio_cubit.dart' as _i929;
import 'package:roadbash/features/menu/cubit/menu_cubit.dart' as _i303;
import 'package:roadbash/features/progress/cubit/progress_cubit.dart' as _i862;
import 'package:roadbash/features/race/cubit/race_cubit.dart' as _i508;
import 'package:roadbash/features/reception/cubit/reception_cubit.dart'
    as _i762;
import 'package:roadbash/features/settings/cubit/settings_cubit.dart' as _i422;
import 'package:roadbash/features/splash/cubit/splash_cubit.dart' as _i809;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i303.MenuCubit>(() => _i303.MenuCubit());
    gh.factory<_i762.ReceptionCubit>(() => _i762.ReceptionCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefsRepo(),
      preResolve: true,
    );
    await gh.singletonAsync<_i686.AppDatabase>(
      () => registerModule.appDatabase(),
      preResolve: true,
    );
    gh.lazySingleton<_i1063.AudioService>(() => _i1063.AudioService());
    gh.lazySingleton<_i624.ProfileRepo>(
      () => _i624.ProfileRepo(gh<_i686.AppDatabase>()),
    );
    gh.lazySingleton<_i541.RaceRepo>(
      () => _i541.RaceRepo(gh<_i686.AppDatabase>()),
    );
    gh.lazySingleton<_i422.SettingsCubit>(
      () => _i422.SettingsCubit(gh<_i624.ProfileRepo>()),
    );
    gh.lazySingleton<_i862.ProgressCubit>(
      () => _i862.ProgressCubit(gh<_i541.RaceRepo>()),
    );
    gh.factory<_i508.RaceCubit>(
      () => _i508.RaceCubit(gh<_i862.ProgressCubit>()),
    );
    gh.lazySingleton<_i929.AudioCubit>(
      () => _i929.AudioCubit(
        gh<_i1063.AudioService>(),
        gh<_i422.SettingsCubit>(),
      ),
    );
    gh.factory<_i809.SplashCubit>(
      () => _i809.SplashCubit(
        gh<_i422.SettingsCubit>(),
        gh<_i862.ProgressCubit>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i970.RegisterModule {}
