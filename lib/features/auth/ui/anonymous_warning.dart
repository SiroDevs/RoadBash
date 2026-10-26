// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../common/l10n/l10n_extension.dart';

Future<void> confirmAnonymous(
  BuildContext context,
  VoidCallback onConfirm,
) async {
  final l10n = context.l10n;
  final s = context.sizes;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: Retro.panel,
      title: Text(
        l10n.anonymousWarningTitle,
        style: retroBody(size: s.body, color: Retro.yellow),
      ),
      content: Text(
        l10n.anonymousWarningBody,
        style: retroBody(size: s.small),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(
            l10n.commonCancel,
            style: retroBody(size: s.small, color: Retro.dim),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          child: Text(
            l10n.anonymousWarningConfirm,
            style: retroBody(size: s.small, color: Retro.orange),
          ),
        ),
      ],
    ),
  );
  if (accepted ?? false) onConfirm();
}
