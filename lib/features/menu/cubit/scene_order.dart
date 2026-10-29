// Project imports:
import '../../../domain/models/scene_id.dart';
import '../../progress/cubit/progress_cubit.dart';
import 'menu_target.dart';

/// The menu entries in display order: the scenes most raced first (ties, and
/// a fresh install, in the usual [SceneId] order), then the reception, which
/// always stays last.
class SceneOrder {
  const SceneOrder(this.scenes, this.mostPlayed);

  factory SceneOrder.from(ProgressState progress) {
    final races = {
      for (final id in SceneId.values) id: progress.statsFor(id).races,
    };
    final scenes = [...SceneId.values]
      ..sort((a, b) {
        final byRaces = races[b]!.compareTo(races[a]!);
        return byRaces != 0 ? byRaces : a.index.compareTo(b.index);
      });
    return SceneOrder(scenes, races[scenes.first]! > 0 ? scenes.first : null);
  }

  final List<SceneId> scenes;

  List<MenuTarget> get items => [
    for (final id in scenes) MenuTarget.scene(id),
    const MenuTarget.reception(),
  ];

  final SceneId? mostPlayed;
}
