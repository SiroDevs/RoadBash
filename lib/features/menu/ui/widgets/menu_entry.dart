// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';

/// One name in the menu grid, with an optional tiny hint above it (used for
/// "most played").
class MenuEntry extends StatelessWidget {
  const MenuEntry({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final hintSize = sizes.caption * 0.6;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Every entry keeps the same room above its name for the hint, so a
        // row of names stays level.
        Padding(
          padding: EdgeInsets.only(top: hintSize * 0.75),
          child: RetroMenuItem(
            center: true,
            selected: selected,
            label: label,
            onTap: onTap,
          ),
        ),
        if (hint != null)
          IgnorePointer(
            child: Text(
              hint!.toUpperCase(),
              maxLines: 1,
              style: retroBody(size: hintSize, color: Retro.yellow),
            ),
          ),
      ],
    );
  }
}
