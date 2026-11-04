// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/feedback/retro_skeleton.dart';
import '../../../common/widgets/retro/retro_style.dart';

// Shimmering stand-in for the leaderboard table while data loads.
class LeaderboardSkeleton extends StatelessWidget {
  const LeaderboardSkeleton({super.key, this.rows = 8});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return RetroShimmer(
      child: Column(
        children: [
          for (var index = 0; index <= rows; index++) _row(sizes, index == 0),
        ],
      ).padding(all: sizes.gap).decorated(
            color: Retro.panel,
            borderRadius: BorderRadius.circular(12),
          ),
    );
  }

  /// Builds one skeleton row; headers use smaller blocks.
  Widget _row(RetroSizes sizes, bool header) {
    final height = header ? sizes.caption : sizes.body;
    return Row(
      children: [
        RetroSkeletonBlock(width: sizes.gap * 2, height: height),
        SizedBox(width: sizes.gap),
        Expanded(child: RetroSkeletonBlock(height: height)),
        SizedBox(width: sizes.gap),
        RetroSkeletonBlock(width: sizes.gap * 3, height: height),
        SizedBox(width: sizes.gap),
        RetroSkeletonBlock(width: sizes.gap * 3, height: height),
      ],
    ).padding(vertical: sizes.gapSmall);
  }
}
