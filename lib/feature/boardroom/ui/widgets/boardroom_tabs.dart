// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/widgets/retro/controls/retro_chips.dart';
import '../../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/boardroom_cubit.dart';

/// The Announcements and Suggestions strips with a refresh button.
class BoardroomTabs extends StatelessWidget {
  const BoardroomTabs({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onRefresh,
  });

  final BoardroomTab selected;
  final ValueChanged<BoardroomTab> onSelected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        RetroChips<BoardroomTab>(
          items: {
            BoardroomTab.announcements: l10n.boardroomAnnouncements,
            BoardroomTab.suggestions: l10n.boardroomSuggestions,
          },
          selected: selected,
          onSelected: onSelected,
        ).expanded(),
        RetroButton(l10n.commonRefresh, onTap: onRefresh),
      ],
    );
  }
}
