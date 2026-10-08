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
import 'package:roadbash/domain/repos/prefs_repo.dart' as _i805;
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
    gh.factory<_i178.SplashCubit>(() => _i178.SplashCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs(),
      preResolve: true,
    );
    gh.singleton<_i805.PrefsRepo>(
      () => _i805.PrefsRepo(gh<_i460.SharedPreferences>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i970.RegisterModule {}
