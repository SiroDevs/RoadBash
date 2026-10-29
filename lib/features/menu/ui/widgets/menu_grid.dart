// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../cubit/menu_target.dart';
import '../../cubit/scene_order.dart';
import 'menu_entry.dart';
import 'menu_target_info.dart';

/// The names of the scenes and the reception laid out as a grid whose columns
/// follow the screen size. Tapping an entry highlights it; tapping the
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
    final cols = columnsFor(MediaQuery.sizeOf(context).width);
    return LayoutBuilder(
      builder: (context, box) {
        final width = (box.maxWidth / cols).floorToDouble();
        return Container(
          color: Retro.panel,
          child: Wrap(
            children: [
              for (final item in order.items)
                SizedBox(
                  width: width,
                  child: MenuEntry(
                    label: menuLabel(l10n, item),
                    selected: item == selected,
                    hint: !item.isReception && item.scene == order.mostPlayed
                        ? l10n.mostPlayed
                        : null,
                    onTap: () => onTap(item),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
