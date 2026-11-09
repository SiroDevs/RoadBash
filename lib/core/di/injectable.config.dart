// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

// Package imports:
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

// Project imports:
import 'package:roadbash/core/audio/audio_service.dart' as _i257;
import 'package:roadbash/core/di/injectable.dart' as _i970;
import 'package:roadbash/data/repos/auth_repo_impl.dart' as _i378;
import 'package:roadbash/data/repos/career_repo_impl.dart' as _i653;
import 'package:roadbash/data/repos/leaderboard_repo_impl.dart' as _i777;
import 'package:roadbash/data/repos/post_repo_impl.dart' as _i1050;
import 'package:roadbash/data/repos/profile_repo_impl.dart' as _i10;
import 'package:roadbash/data/repos/race_repo_impl.dart' as _i101;
import 'package:roadbash/data/repos/stats_repo_impl.dart' as _i332;
import 'package:roadbash/data/repos/wallet_repo_impl.dart' as _i964;
import 'package:roadbash/data/sources/local/prefs_source.dart' as _i810;
import 'package:roadbash/data/sources/remote/api_client.dart' as _i27;
import 'package:roadbash/data/sources/remote/geo_source.dart' as _i118;
import 'package:roadbash/domain/repos/auth_repo.dart' as _i505;
import 'package:roadbash/domain/repos/career_repo.dart' as _i16;
import 'package:roadbash/domain/repos/leaderboard_repo.dart' as _i808;
import 'package:roadbash/domain/repos/post_repo.dart' as _i1062;
import 'package:roadbash/domain/repos/profile_repo.dart' as _i624;
import 'package:roadbash/domain/repos/race_repo.dart' as _i541;
import 'package:roadbash/domain/repos/stats_repo.dart' as _i1072;
import 'package:roadbash/domain/repos/wallet_repo.dart' as _i498;
import 'package:roadbash/feature/audio/cubit/audio_cubit.dart' as _i985;
import 'package:roadbash/feature/auth/cubit/auth_cubit.dart' as _i570;
import 'package:roadbash/feature/auth/cubit/sign_in_cubit.dart' as _i659;
import 'package:roadbash/feature/boardroom/cubit/boardroom_cubit.dart' as _i802;
import 'package:roadbash/feature/menu/cubit/menu_cubit.dart' as _i158;
import 'package:roadbash/feature/menu/cubit/menu_memory.dart' as _i615;
import 'package:roadbash/feature/menu/cubit/online_cubit.dart' as _i198;
import 'package:roadbash/feature/progress/cubit/progress_cubit.dart' as _i419;
import 'package:roadbash/feature/race/cubit/race_cubit.dart' as _i614;
import 'package:roadbash/feature/reception/cubit/reception_cubit.dart' as _i899;
import 'package:roadbash/feature/settings/cubit/settings_cubit.dart' as _i751;
import 'package:roadbash/feature/splash/cubit/splash_cubit.dart' as _i178;
import 'package:roadbash/feature/stats/cubit/stats_cubit.dart' as _i249;
import 'package:roadbash/feature/wallet/cubit/wallet_cubit.dart' as _i1008;

import 'package:roadbash/feature/leaderboard/cubit/leaderboard_cubit.dart'
    as _i695;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i899.ReceptionCubit>(() => _i899.ReceptionCubit());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPrefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i257.AudioService>(() => _i257.AudioService());
    gh.lazySingleton<_i27.ApiClient>(() => _i27.ApiClient());
    gh.lazySingleton<_i118.GeoSource>(() => _i118.GeoSource());
    gh.lazySingleton<_i615.MenuMemory>(() => _i615.MenuMemory());
    gh.singleton<_i810.PrefsSource>(
      () => _i810.PrefsSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1072.StatsRepo>(
      () => _i332.StatsRepoImpl(
        gh<_i27.ApiClient>(),
        gh<_i810.PrefsSource>(),
        gh<_i118.GeoSource>(),
      ),
    );
    gh.lazySingleton<_i624.ProfileRepo>(
      () => _i10.ProfileRepoImpl(gh<_i810.PrefsSource>()),
    );
    gh.factory<_i158.MenuCubit>(() => _i158.MenuCubit(gh<_i615.MenuMemory>()));
    gh.lazySingleton<_i16.CareerRepo>(
      () => _i653.CareerRepoImpl(gh<_i810.PrefsSource>()),
    );
    gh.lazySingleton<_i751.SettingsCubit>(
      () => _i751.SettingsCubit(gh<_i624.ProfileRepo>()),
    );
    gh.lazySingleton<_i498.WalletRepo>(
      () => _i964.WalletRepoImpl(gh<_i27.ApiClient>()),
    );
    gh.lazySingleton<_i808.LeaderboardRepo>(
      () => _i777.LeaderboardRepoImpl(gh<_i27.ApiClient>()),
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
    gh.lazySingleton<_i1062.PostRepo>(
      () => _i1050.PostRepoImpl(gh<_i27.ApiClient>()),
    );
    gh.lazySingleton<_i541.RaceRepo>(
      () => _i101.RaceRepoImpl(gh<_i27.ApiClient>()),
    );
    gh.lazySingleton<_i505.AuthRepo>(
      () => _i378.AuthRepoImpl(gh<_i27.ApiClient>(), gh<_i810.PrefsSource>()),
    );
    gh.lazySingleton<_i985.AudioCubit>(
      () =>
          _i985.AudioCubit(gh<_i257.AudioService>(), gh<_i751.SettingsCubit>()),
    );
    gh.lazySingleton<_i419.ProgressCubit>(
      () => _i419.ProgressCubit(gh<_i541.RaceRepo>(), gh<_i16.CareerRepo>()),
    );
    gh.lazySingleton<_i1008.WalletCubit>(
      () => _i1008.WalletCubit(gh<_i498.WalletRepo>(), gh<_i505.AuthRepo>()),
    );
    gh.lazySingleton<_i570.AuthCubit>(
      () => _i570.AuthCubit(
        gh<_i505.AuthRepo>(),
        gh<_i751.SettingsCubit>(),
        gh<_i419.ProgressCubit>(),
      ),
    );
    gh.factory<_i802.BoardroomCubit>(
      () => _i802.BoardroomCubit(gh<_i1062.PostRepo>(), gh<_i505.AuthRepo>()),
    );
    gh.factory<_i178.SplashCubit>(
      () => _i178.SplashCubit(
        gh<_i751.SettingsCubit>(),
        gh<_i419.ProgressCubit>(),
        gh<_i1072.StatsRepo>(),
        gh<_i570.AuthCubit>(),
      ),
    );
    gh.factory<_i659.SignInCubit>(
      () => _i659.SignInCubit(gh<_i505.AuthRepo>(), gh<_i570.AuthCubit>()),
    );
    gh.factory<_i614.RaceCubit>(
      () =>
          _i614.RaceCubit(gh<_i419.ProgressCubit>(), gh<_i1008.WalletCubit>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i970.RegisterModule {}
