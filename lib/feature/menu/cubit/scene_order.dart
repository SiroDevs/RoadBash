// Project imports:
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/scene_id.dart';
import '../../progress/cubit/progress_cubit.dart';
import 'menu_target.dart';

/// Menu entries in a stable order: scenes first, then the rest.
class SceneOrder {
  const SceneOrder(this.rules);

  factory SceneOrder.from(ProgressState progress) {
    return SceneOrder(LevelRules.of(progress.level));
  }

  /// The scene targets in their stable game order.
  List<MenuTarget> get sceneItems => [
    for (final id in SceneId.values) MenuTarget.scene(id),
  ];

  /// The targets after the scenes: the reception, then the boardroom.
  List<MenuTarget> get otherItems => const [
    MenuTarget.reception(),
    MenuTarget.boardroom(),
  ];

  /// Every menu target in display order.
  List<MenuTarget> get items => [...sceneItems, ...otherItems];

  /// The rules of the player's level, which decide what is open.
  final LevelRules rules;

  /// True when the player's level does not open [scene] yet.
  bool isLocked(SceneId scene) => !rules.isOpen(scene);
}
