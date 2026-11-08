// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/level_rules.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/menu_target.dart';
import '../../cubit/scene_order.dart';
import 'menu_entry.dart';
import 'menu_target_info.dart';

/// The scenes in a container, a line, then the reception and the boardroom each in their own.
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
          _scenesPanel(context, (box.maxWidth / columns).floorToDouble()),
          const _Separator(),
          _otherRow(context),
        ],
      ),
    );
  }

  /// The scenes container: the label above the grid.
  Widget _scenesPanel(BuildContext context, double cellWidth) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _ScenesLabel(),
      _sceneGrid(context, cellWidth),
    ],
  ).decorated(color: Retro.panel);

  /// The scene entries, wrapped into rows of equal-width cells.
  Widget _sceneGrid(BuildContext context, double cellWidth) {
    final l10n = context.l10n;
    return Wrap(
      children: [
        for (final item in order.sceneItems)
          MenuEntry(
            label: menuLabel(l10n, item),
            selected: item == selected,
            hint: order.isLocked(item.scene!)
                ? l10n.levelLabel(LevelRules.unlockLevelOf(item.scene!)).toUpperCase()
                : item.scene == order.mostPlayed
                ? l10n.mostPlayed
                : null,
            onTap: () => onTap(item),
          ).constrained(width: cellWidth),
      ],
    );
  }

  /// The reception and the boardroom side by side, each in its own container.
  Widget _otherRow(BuildContext context) {
    return Row(
      children: [
        _otherEntry(context, order.otherItems.first).expanded(),
        SizedBox(width: context.sizes.gapSmall),
        _otherEntry(context, order.otherItems.last).expanded(),
      ],
    );
  }

  /// One entry of the second part, in its own container.
  Widget _otherEntry(BuildContext context, MenuTarget item) => MenuEntry(
    label: menuLabel(context.l10n, item),
    selected: item == selected,
    onTap: () => onTap(item),
  ).decorated(color: Retro.panel);
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
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return const SizedBox(
      height: 2,
      child: ColoredBox(color: Retro.dim),
    ).padding(horizontal: sizes.gap, vertical: sizes.gapSmall);
  }
}
