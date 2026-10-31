// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import 'rider_bar.dart';

/// Lays out the title, info, card and entries in a fixed column.
class MenuFixedLayout extends StatelessWidget {
  const MenuFixedLayout({
    super.key,
    required this.title,
    required this.info,
    required this.card,
    required this.entries,
  });

  static const double cardScale = 0.75;

  final Widget title;
  final Widget info;
  final Widget card;
  final Widget entries;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: sizes.gapSmall),
        LayoutBuilder(
          builder: (context, box) => box.maxWidth > 640
              ? Row(
                  children: [
                    SingleChildScrollView(child: info).expanded(),
                    SizedBox(width: sizes.gap * 1.5),
                    _smaller(card).center().expanded(),
                  ],
                )
              : Column(
                  children: [
                    _smaller(card).center().expanded(),
                    SizedBox(height: sizes.gapSmall),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: box.maxHeight * 0.45,
                      ),
                      child: SingleChildScrollView(child: info),
                    ),
                  ],
                ),
        ).expanded(),
        SizedBox(height: sizes.gapSmall),
        const RiderBar(),
        SizedBox(height: sizes.gapSmall * 0.75),
        entries,
      ],
    );
  }

  /// Shrinks the scene card to fit beside the entries.
  Widget _smaller(Widget card) =>
      FractionallySizedBox(widthFactor: cardScale, child: card);
}
