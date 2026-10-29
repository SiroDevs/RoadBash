// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/constants/app_assets.dart';
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/click_sound.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/scene_id.dart';
import '../../cubit/menu_target.dart';

/// Returns the preview image asset for a scene.
String sceneAsset(SceneId id) => switch (id) {
  SceneId.city => AppAssets.sceneCity,
  SceneId.suburbs => AppAssets.sceneSuburbs,
  SceneId.thikaRoad => AppAssets.sceneThikaRoad,
  SceneId.jungle => AppAssets.sceneJungle,
  SceneId.dirtRoad => AppAssets.sceneDirtRoad,
};

/// The picture of a menu entry; the reception has its own.
String menuAsset(MenuTarget target) => target.isReception
    ? AppAssets.restroom
    : sceneAsset(target.scene!);

/// One entry of the menu grid: its picture and name, highlighted when
/// selected, with a small "most played" hint on the player's favourite scene.
class SceneTile extends StatelessWidget {
  const SceneTile({
    super.key,
    required this.image,
    required this.label,
    required this.selected,
    required this.mostPlayed,
    required this.onTap,
    required this.onHighlight,
  });

  final String image;
  final String label;
  final bool selected;
  final bool mostPlayed;
  final VoidCallback onTap;

  final VoidCallback onHighlight;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final l10n = context.l10n;
    return InkWell(
      onTap: () {
        playClick(context);
        onTap();
      },
      onHover: (hovering) {
        if (hovering) onHighlight();
      },
      onLongPress: onHighlight,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Retro.panel,
          border: Border.all(
            color: selected ? Retro.yellow : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (mostPlayed)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      color: Retro.yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      child: Text(
                        l10n.mostPlayed.toUpperCase(),
                        maxLines: 1,
                        style: TextStyle(
                          color: Retro.ink,
                          fontSize: sizes.caption * 0.85,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: sizes.gapSmall),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: retroBody(
                  size: sizes.small,
                  color: selected ? Colors.white : Retro.dim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
