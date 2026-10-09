// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../core/di/injectable.dart';
import '../../feature/menu/cubit/menu_cubit.dart';
import '../../feature/menu/menu_screen.dart';
import '../../feature/notice/notice_screen.dart';
import '../../feature/splash/cubit/splash_cubit.dart';
import '../../feature/splash/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static Widget _provide<C extends Cubit<Object?>>(Widget child) =>
      BlocProvider<C>(create: (_) => getIt<C>(), child: child);

  static GoRouter create({String initialLocation = '/race/city'}) {
    return GoRouter(
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
      //   GoRoute(
      //     path: RoutePaths.race,
      //     name: RouteNames.race,
      //     builder: (context, state) {
      //       final id = SceneId.values.asNameMap()[state.pathParameters['scene']];
      //       return _provide<RaceCubit>(
      //         RaceScreen(key: ValueKey(id), scene: id ?? SceneId.city),
      //       );
      //     },
      //   ),
      //   GoRoute(
      //     path: RoutePaths.results,
      //     name: RouteNames.results,
      //     builder: (context, state) {
      //       final outcome = state.extra;
      //       return outcome is RaceOutcome
      //           ? ResultsScreen(outcome: outcome)
      //           : _provide<MenuCubit>(const MenuScreen());
      //     },
      //   ),
      //   GoRoute(
      //     path: RoutePaths.reception,
      //     name: RouteNames.reception,
      //     builder: (context, state) =>
      //         _provide<ReceptionCubit>(const ReceptionScreen()),
      //   ),
      ],
      errorBuilder: (context, state) =>
          _provide<SplashCubit>(const SplashScreen()),
    );
  }
}
