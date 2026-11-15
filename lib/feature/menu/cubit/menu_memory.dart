// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'menu_target.dart';

/// Remembers the next menu selection and most recently selected scene.
@lazySingleton
class MenuMemory {
  MenuTarget? last;
  MenuTarget? lastScene;
}
