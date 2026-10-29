// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../domain/models/scene_id.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/sign_in_cubit.dart';
import '../../features/auth/ui/sign_in_screen.dart';
import '../../features/leaderboard/cubit/leaderboard_cubit.dart';
import '../../features/leaderboard/ui/leaderboard_screen.dart';
import '../../features/menu/cubit/menu_cubit.dart';
import '../../features/menu/ui/menu_screen.dart';
import '../../features/notice/notice_screen.dart';
import '../../features/race/cubit/race_cubit.dart';
import '../../features/race/ui/race_screen.dart';
import '../../features/reception/cubit/reception_cubit.dart';
import '../../features/reception/ui/reception_screen.dart';
import '../../features/results/results_screen.dart';
import '../../features/splash/cubit/splash_cubit.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/stats/cubit/stats_cubit.dart';
import '../../features/stats/ui/stats_screen.dart';
import '../di/injectable.dart';
import 'route_names.dart';

/// Notifies the router when the sign-in state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Stream<AuthState> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Creates the app's routes and redirects.
class AppRouter {
  AppRouter._();

  static const _open = {
    RoutePaths.splash,
    RoutePaths.notice,
    RoutePaths.signIn,
  };

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Provides a cubit to a route's page.
  static Widget _provide<C extends Cubit<Object?>>(Widget child) =>
      BlocProvider<C>(create: (_) => getIt<C>(), child: child);

  /// Builds the router.
  static GoRouter create({String initialLocation = RouteNames.splash}) {
    final auth = getIt<AuthCubit>();
    return GoRouter(
      refreshListenable: _AuthListenable(auth.stream),
      redirect: (context, state) =>
          auth.state.isSignedIn || _open.contains(state.uri.path)
          ? null
          : RoutePaths.splash,
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) =>
              _provide<SplashCubit>(const SplashScreen()),
        ),
        GoRoute(
          path: RoutePaths.notice,
          name: RouteNames.notice,
          builder: (context, state) => const NoticeScreen(),
        ),
        GoRoute(
          path: RoutePaths.menu,
          name: RouteNames.menu,
          builder: (context, state) => _provide<MenuCubit>(const MenuScreen()),
        ),
        GoRoute(
          path: RoutePaths.race,
          name: RouteNames.race,
          builder: (context, state) {
            final id = SceneId.values.asNameMap()[state.pathParameters['scene']];
            return _provide<RaceCubit>(
              RaceScreen(key: ValueKey(id), scene: id ?? SceneId.city),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.results,
          name: RouteNames.results,
          builder: (context, state) {
            final outcome = state.extra;
            return outcome is RaceOutcome
                ? ResultsScreen(outcome: outcome)
                : _provide<MenuCubit>(const MenuScreen());
          },
        ),
        GoRoute(
          path: RoutePaths.reception,
          name: RouteNames.reception,
          builder: (context, state) =>
              _provide<ReceptionCubit>(const ReceptionScreen()),
        ),
        GoRoute(
          path: RoutePaths.signIn,
          name: RouteNames.signIn,
          builder: (context, state) =>
              _provide<SignInCubit>(const SignInScreen()),
        ),
        GoRoute(
          path: RoutePaths.stats,
          name: RouteNames.stats,
          builder: (context, state) => BlocProvider<StatsCubit>(
            create: (_) => getIt<StatsCubit>()..load(),
            child: const StatsScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.leaderboard,
          name: RouteNames.leaderboard,
          builder: (context, state) => BlocProvider<LeaderboardCubit>(
            create: (_) => getIt<LeaderboardCubit>()..load(),
            child: const LeaderboardScreen(),
          ),
        ),
      ],
      errorBuilder: (context, state) =>
          _provide<SplashCubit>(const SplashScreen()),
    );
  }
}
