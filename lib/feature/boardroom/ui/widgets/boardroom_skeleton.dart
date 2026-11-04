// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/feedback/retro_skeleton.dart';
import '../../../../common/widgets/retro/retro_card.dart';

/// Shimmering stand-in for the post cards while data loads.
class BoardroomSkeleton extends StatelessWidget {
  const BoardroomSkeleton({super.key, this.cards = 3});

  final int cards;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return RetroShimmer(
      child: Column(
        children: [
          for (var index = 0; index < cards; index++) _card(sizes),
        ],
      ),
    );
  }

  /// One placeholder card: meta line, two message lines and an action.
  Widget _card(RetroSizes sizes) => RetroCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroSkeletonBlock(width: sizes.gap * 10, height: sizes.caption),
        SizedBox(height: sizes.gap),
        RetroSkeletonBlock(height: sizes.small),
        SizedBox(height: sizes.gapSmall),
        RetroSkeletonBlock(width: sizes.gap * 16, height: sizes.small),
        SizedBox(height: sizes.gap),
        RetroSkeletonBlock(width: sizes.gap * 4, height: sizes.caption),
      ],
    ),
  ).padding(bottom: sizes.gapSmall);
}
