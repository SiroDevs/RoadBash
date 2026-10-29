// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'menu_target.dart';

/// Where the player last went from the menu (a scene or the reception), so
/// coming back to the menu lands on it again. Lives as long as the app.
@lazySingleton
class MenuMemory {
  MenuTarget? last;
}
