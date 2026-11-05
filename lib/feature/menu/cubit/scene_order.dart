// Project imports:
import '../../../domain/models/level_rules.dart';
import '../../../domain/models/scene_id.dart';
import '../../progress/cubit/progress_cubit.dart';
import 'menu_target.dart';

/// Menu entries in display order: scenes by races played, then the rest.
class SceneOrder {
  const SceneOrder(this.scenes, this.mostPlayed, this.rules);

  factory SceneOrder.from(ProgressState progress) {
    final races = {
      for (final id in SceneId.values) id: progress.statsFor(id).races,
    };
    final scenes = [...SceneId.values]
      ..sort((a, b) {
        final byRaces = races[b]!.compareTo(races[a]!);
        return byRaces != 0 ? byRaces : a.index.compareTo(b.index);
      });
    return SceneOrder(
      scenes,
      races[scenes.first]! > 0 ? scenes.first : null,
      LevelRules.of(progress.level),
    );
  }

  final List<SceneId> scenes;

  /// The scene targets, ordered by races played.
  List<MenuTarget> get sceneItems => [
    for (final id in scenes) MenuTarget.scene(id),
  ];

  /// The targets after the scenes: the reception, then the boardroom.
  List<MenuTarget> get otherItems => const [
    MenuTarget.reception(),
    MenuTarget.boardroom(),
  ];

  /// Every menu target in display order.
  List<MenuTarget> get items => [...sceneItems, ...otherItems];

  final SceneId? mostPlayed;

  /// The rules of the player's level, which decide what is open.
  final LevelRules rules;

  /// True when the player's level does not open [scene] yet.
  bool isLocked(SceneId scene) => !rules.isOpen(scene);
}
