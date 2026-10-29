// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/feedback/retro_skeleton.dart';
import '../../../../common/widgets/retro/retro_style.dart';

// Shimmering stand-in for the stats charts while data loads.
class ChartSkeleton extends StatelessWidget {
  const ChartSkeleton({super.key, this.panels = 3});

  final int panels;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return RetroShimmer(
      child: Column(
        children: [
          for (var index = 0; index < panels; index++) ...[
            if (index > 0) SizedBox(height: sizes.gap),
            _panel(sizes),
          ],
        ],
      ),
    );
  }

  Widget _panel(RetroSizes sizes) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RetroSkeletonBlock(width: sizes.gap * 8, height: sizes.small),
                RetroSkeletonBlock(width: sizes.gap * 4, height: sizes.caption),
              ],
            ),
            SizedBox(height: sizes.gapSmall),
            RetroSkeletonBlock(height: sizes.gap * 8),
            SizedBox(height: sizes.gapSmall * 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < 3; index++)
                  RetroSkeletonBlock(width: sizes.gap * 3, height: sizes.caption),
              ],
            ),
          ],
        )
        .padding(all: sizes.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }
}
