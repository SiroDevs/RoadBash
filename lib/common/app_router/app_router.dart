// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../features/game/race_result.dart';
import '../../features/menu/menu_screen.dart';
import '../../features/notice/notice_screen.dart';
import '../../features/race/race_screen.dart';
import '../../features/reception/reception_screen.dart';
import '../../features/results/results_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../widgets/game/road_theme.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter create({String initialLocation = RoutePaths.splash}) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: RoutePaths.notice,
          name: RouteNames.notice,
          builder: (context, state) => const NoticeScreen(),
        ),
        GoRoute(
          path: RoutePaths.menu,
          name: RouteNames.menu,
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: RoutePaths.race,
          name: RouteNames.race,
          builder: (context, state) {
            final id = SceneId.values.asNameMap()[state.pathParameters['scene']];
            return RaceScreen(
              key: ValueKey(id),
              scene: id ?? SceneId.city,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.results,
          name: RouteNames.results,
          builder: (context, state) {
            final result = state.extra;
            return result is RaceResult
                ? ResultsScreen(result: result)
                : const MenuScreen();
          },
        ),
        GoRoute(
          path: RoutePaths.reception,
          name: RouteNames.reception,
          builder: (context, state) => const ReceptionScreen(),
        ),
      ],
      errorBuilder: (context, state) => const SplashScreen(),
    );
  }
}
