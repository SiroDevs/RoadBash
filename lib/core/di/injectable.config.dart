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
import 'package:roadbash/core/auth/auth_cubit.dart' as _i961;
import 'package:roadbash/core/di/injectable.dart' as _i970;
import 'package:roadbash/core/progress/progress_cubit.dart' as _i641;
import 'package:roadbash/core/settings/settings_cubit.dart' as _i550;
import 'package:roadbash/core/supabase/api_client.dart' as _i738;
import 'package:roadbash/domain/repos/auth_repo.dart' as _i505;
import 'package:roadbash/domain/repos/leaderboard_repo.dart' as _i808;
import 'package:roadbash/domain/repos/prefs_repo.dart' as _i805;
import 'package:roadbash/domain/repos/profile_repo.dart' as _i624;
import 'package:roadbash/domain/repos/race_repo.dart' as _i541;
import 'package:roadbash/domain/repos/stats_repo.dart' as _i1072;
import 'package:roadbash/domain/repos/suggestion_repo.dart' as _i269;
import 'package:roadbash/feature/auth/cubit/sign_in_cubit.dart' as _i659;
import 'package:roadbash/feature/leaderboard/cubit/leaderboard_cubit.dart'
    as _i695;
import 'package:roadbash/feature/menu/cubit/menu_cubit.dart' as _i158;
import 'package:roadbash/feature/menu/cubit/online_cubit.dart' as _i198;
import 'package:roadbash/feature/race/cubit/race_cubit.dart' as _i614;
import 'package:roadbash/feature/reception/cubit/reception_cubit.dart' as _i899;
import 'package:roadbash/feature/splash/cubit/splash_cubit.dart' as _i178;
import 'package:roadbash/feature/stats/cubit/stats_cubit.dart' as _i249;
import 'package:roadbash/feature/suggestions/cubit/suggestion_cubit.dart'
    as _i96;
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
    gh.factory<_i899.ReceptionCubit>(() => _i899.ReceptionCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i257.AudioService>(() => _i257.AudioService());
    gh.lazySingleton<_i738.ApiClient>(() => _i738.ApiClient());
    gh.singleton<_i805.PrefsRepo>(
      () => _i805.PrefsRepo(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i624.ProfileRepo>(
      () => _i624.ProfileRepo(gh<_i805.PrefsRepo>()),
    );
    gh.lazySingleton<_i505.AuthRepo>(
      () => _i505.AuthRepo(gh<_i738.ApiClient>()),
    );
    gh.lazySingleton<_i808.LeaderboardRepo>(
      () => _i808.LeaderboardRepo(gh<_i738.ApiClient>()),
    );
    gh.lazySingleton<_i541.RaceRepo>(
      () => _i541.RaceRepo(gh<_i738.ApiClient>()),
    );
    gh.lazySingleton<_i269.SuggestionRepo>(
      () => _i269.SuggestionRepo(gh<_i738.ApiClient>()),
    );
    gh.factory<_i96.SuggestionCubit>(
      () => _i96.SuggestionCubit(
        gh<_i269.SuggestionRepo>(),
        gh<_i738.ApiClient>(),
      ),
    );
    gh.lazySingleton<_i550.SettingsCubit>(
      () => _i550.SettingsCubit(gh<_i624.ProfileRepo>()),
    );
    gh.lazySingleton<_i641.ProgressCubit>(
      () => _i641.ProgressCubit(gh<_i541.RaceRepo>()),
    );
    gh.lazySingleton<_i1072.StatsRepo>(
      () => _i1072.StatsRepo(gh<_i738.ApiClient>(), gh<_i805.PrefsRepo>()),
    );
    gh.factory<_i695.LeaderboardCubit>(
      () => _i695.LeaderboardCubit(gh<_i808.LeaderboardRepo>()),
    );
    gh.factory<_i198.OnlineCubit>(
      () => _i198.OnlineCubit(gh<_i1072.StatsRepo>()),
    );
    gh.factory<_i249.StatsCubit>(
      () => _i249.StatsCubit(gh<_i1072.StatsRepo>()),
    );
    gh.factory<_i614.RaceCubit>(
      () => _i614.RaceCubit(gh<_i641.ProgressCubit>()),
    );
    gh.lazySingleton<_i961.AuthCubit>(
      () => _i961.AuthCubit(
        gh<_i505.AuthRepo>(),
        gh<_i738.ApiClient>(),
        gh<_i550.SettingsCubit>(),
        gh<_i641.ProgressCubit>(),
        gh<_i805.PrefsRepo>(),
      ),
    );
    gh.lazySingleton<_i683.AudioCubit>(
      () =>
          _i683.AudioCubit(gh<_i257.AudioService>(), gh<_i550.SettingsCubit>()),
    );
    gh.factory<_i178.SplashCubit>(
      () => _i178.SplashCubit(
        gh<_i550.SettingsCubit>(),
        gh<_i641.ProgressCubit>(),
        gh<_i1072.StatsRepo>(),
        gh<_i961.AuthCubit>(),
      ),
    );
    gh.factory<_i659.SignInCubit>(
      () => _i659.SignInCubit(gh<_i505.AuthRepo>(), gh<_i961.AuthCubit>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i970.RegisterModule {}
