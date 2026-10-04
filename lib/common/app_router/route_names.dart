/// Route names, used with `context.goNamed(...)`.
class RouteNames {
  RouteNames._();

  static const splash = 'splash';
  static const auth = 'auth';
  static const password = 'password';
  static const home = 'home';
  static const profile = 'profile';
  static const settings = 'settings';
}

/// URL paths for each route (what GoRouter matches against).
class RoutePaths {
  RoutePaths._();

  static const splash = '/';
  static const home = '/home';
}
