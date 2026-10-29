// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import '../retro_style.dart';
import 'click_sound.dart';

/// Row of selectable chips.
class RetroChips<T> extends StatelessWidget {
  const RetroChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final Map<T, String> items;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Wrap(
      spacing: sizes.gapSmall,
      runSpacing: sizes.gapSmall,
      children: [
        for (final entry in items.entries)
          Text(
            entry.value,
            style: retroBody(
              size: sizes.caption,
              color: entry.key == selected ? Retro.ink : Colors.white,
            ),
          )
              .padding(horizontal: sizes.gap, vertical: sizes.gapSmall)
              .decorated(
                color: entry.key == selected ? Retro.orange : Retro.panel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: entry.key == selected ? Retro.orange : Retro.dim,
                ),
              )
              .gestures(
                onTap: () {
                  playClick(context);
                  onSelected(entry.key);
                },
              ),
      ],
    );
  }
}
