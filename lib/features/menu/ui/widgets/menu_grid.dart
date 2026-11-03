// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../cubit/menu_target.dart';
import '../../cubit/scene_order.dart';
import 'menu_entry.dart';
import 'menu_target_info.dart';

/// The menu in two parts: the scenes under a "Scenes" label as a grid whose
/// columns follow the screen size, a line, then the reception and the
/// boardroom side by side. Tapping an entry highlights it; tapping the
/// highlighted entry opens it.
class MenuGrid extends StatelessWidget {
  const MenuGrid({
    super.key,
    required this.order,
    required this.selected,
    required this.onTap,
  });

  final SceneOrder order;
  final MenuTarget selected;
  final ValueChanged<MenuTarget> onTap;

  /// 5 across on a laptop, 3 on wide phones and tablets, 2 on a phone.
  static int columnsFor(double screenWidth) =>
      screenWidth >= 900 ? 5 : (screenWidth >= 560 ? 3 : 2);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final cols = columnsFor(MediaQuery.sizeOf(context).width);
    return LayoutBuilder(
      builder: (context, box) {
        final width = (box.maxWidth / cols).floorToDouble();
        return Container(
          color: Retro.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  sizes.gap,
                  sizes.gapSmall,
                  sizes.gap,
                  0,
                ),
                child: Text(
                  l10n.menuScenes.toUpperCase(),
                  style: retroBody(size: sizes.caption, color: Retro.yellow),
                ),
              ),
              Wrap(
                children: [
                  for (final item in order.sceneItems)
                    SizedBox(
                      width: width,
                      child: MenuEntry(
                        label: menuLabel(l10n, item),
                        selected: item == selected,
                        hint: item.scene == order.mostPlayed
                            ? l10n.mostPlayed
                            : null,
                        onTap: () => onTap(item),
                      ),
                    ),
                ],
              ),
              Container(
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: sizes.gap),
                color: Retro.dim,
              ),
              Row(
                children: [
                  for (final item in order.otherItems)
                    Expanded(
                      child: MenuEntry(
                        label: menuLabel(l10n, item),
                        selected: item == selected,
                        onTap: () => onTap(item),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
