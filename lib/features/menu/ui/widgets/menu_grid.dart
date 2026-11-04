// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/menu_target.dart';
import '../../cubit/scene_order.dart';
import 'menu_entry.dart';
import 'menu_target_info.dart';

/// The scenes under a label, a line, then the reception and the boardroom.
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
    final columns = columnsFor(MediaQuery.sizeOf(context).width);
    return LayoutBuilder(
      builder: (context, box) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ScenesLabel(),
          _sceneGrid(context, (box.maxWidth / columns).floorToDouble()),
          const _Separator(),
          _otherRow(context),
        ],
      ).decorated(color: Retro.panel),
    );
  }

  /// The scene entries, wrapped into rows of equal-width cells.
  Widget _sceneGrid(BuildContext context, double cellWidth) {
    final l10n = context.l10n;
    return Wrap(
      children: [
        for (final item in order.sceneItems)
          MenuEntry(
            label: menuLabel(l10n, item),
            selected: item == selected,
            hint: item.scene == order.mostPlayed ? l10n.mostPlayed : null,
            onTap: () => onTap(item),
          ).constrained(width: cellWidth),
      ],
    );
  }

  /// The reception and the boardroom side by side.
  Widget _otherRow(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        for (final item in order.otherItems)
          MenuEntry(
            label: menuLabel(l10n, item),
            selected: item == selected,
            onTap: () => onTap(item),
          ).expanded(),
      ],
    );
  }
}

/// The "Scenes" label above the scene grid.
class _ScenesLabel extends StatelessWidget {
  const _ScenesLabel();

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Text(
      context.l10n.menuScenes.toUpperCase(),
      style: retroBody(size: sizes.caption, color: Retro.yellow),
    ).padding(horizontal: sizes.gap, top: sizes.gapSmall);
  }
}

/// The line between the scenes and the reception/boardroom row.
class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 2,
    child: ColoredBox(color: Retro.dim),
  ).padding(horizontal: context.sizes.gap);
}
