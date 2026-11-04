// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../l10n/l10n_extension.dart';
import '../../../layout/retro_sizes.dart';
import '../retro_style.dart';

/// Asks the player to confirm an action; true when confirmed.
Future<bool> showRetroConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  Color confirmColor = Retro.red,
}) async {
  final sizes = context.sizes;
  final cancelLabel = context.l10n.commonCancel;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: Retro.panel,
      shape: const RoundedRectangleBorder(),
      title: Text(title, style: retroBody(size: sizes.body, color: Retro.yellow)),
      content: Text(body, style: retroBody(size: sizes.small)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(false),
          child: Text(cancelLabel, style: retroBody(size: sizes.small, color: Retro.dim)),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialog).pop(true),
          child: Text(confirmLabel, style: retroBody(size: sizes.small, color: confirmColor)),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
