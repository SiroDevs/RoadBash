// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/retro_style.dart';

/// Warns that anonymous play skips saving progress, then confirms.
Future<void> confirmAnonymous(
  BuildContext context,
  VoidCallback onConfirm,
) async {
  final l10n = context.l10n;
  final sizes = context.sizes;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: Retro.panel,
      title: Text(
        l10n.anonymousWarningTitle,
        style: retroBody(size: sizes.body, color: Retro.yellow),
      ),
      content: Text(
        l10n.anonymousWarningBody,
        style: retroBody(size: sizes.small),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(
            l10n.commonCancel,
            style: retroBody(size: sizes.small, color: Retro.dim),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          child: Text(
            l10n.anonymousWarningConfirm,
            style: retroBody(size: sizes.small, color: Retro.orange),
          ),
        ),
      ],
    ),
  );
  if (accepted ?? false) onConfirm();
}
