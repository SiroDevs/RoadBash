// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../l10n/l10n_extension.dart';
import '../../../layout/retro_sizes.dart';
import '../controls/retro_controls.dart';
import '../retro_style.dart';

/// Placeholder shown while data loads.
class RetroLoading extends StatelessWidget {
  const RetroLoading({super.key});

  @override
  Widget build(BuildContext context) =>
      const CircularProgressIndicator(color: Retro.orange).center();
}

/// Message with a retry button shown when loading fails.
class RetroFailure extends StatelessWidget {
  const RetroFailure({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.errNetwork,
          style: retroBody(size: sizes.body, color: Retro.red),
        ),
        SizedBox(height: sizes.gap),
        RetroButton(context.l10n.commonRetry, onTap: onRetry),
      ],
    );
  }
}
