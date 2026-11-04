// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import '../retro_style.dart';
import 'click_sound.dart';

/// Small tappable text link that plays the click sound.
class RetroLinkButton extends StatelessWidget {
  const RetroLinkButton(
    this.label, {
    super.key,
    required this.onTap,
    this.color = Retro.orange,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Text(
      label.toUpperCase(),
      style: retroBody(size: sizes.caption, color: color),
    ).padding(vertical: sizes.gapSmall * 0.4).gestures(
      onTap: () {
        playClick(context);
        onTap();
      },
    );
  }
}
