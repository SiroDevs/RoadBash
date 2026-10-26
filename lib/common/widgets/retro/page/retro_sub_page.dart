// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../l10n/l10n_extension.dart';
import '../../../layout/retro_sizes.dart';
import '../controls/retro_controls.dart';
import '../retro_style.dart';

class RetroSubPage extends StatelessWidget {
  const RetroSubPage({
    super.key,
    required this.title,
    required this.onBack,
    required this.maxWidth,
    required this.children,
  });

  final String title;
  final VoidCallback onBack;
  final double maxWidth;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RetroTitle(title).expanded(),
            RetroButton(context.l10n.commonBack, onTap: onBack),
          ],
        ),
        SizedBox(height: s.gap),
        ...children,
      ],
    ).constrained(maxWidth: maxWidth).alignment(Alignment.topCenter);
  }
}
