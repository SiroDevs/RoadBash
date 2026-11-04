// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/widgets/retro/dialogs/retro_confirm.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/boardroom_cubit.dart';

/// Asks before deleting a post or comment, then deletes it.
Future<void> confirmDeletePost(BuildContext context, int id) async {
  final l10n = context.l10n;
  final cubit = context.read<BoardroomCubit>();
  final confirmed = await showRetroConfirm(
    context,
    title: l10n.boardroomDeleteTitle,
    body: l10n.boardroomDeleteBody,
    confirmLabel: l10n.boardroomDelete,
  );
  if (confirmed) await cubit.delete(id);
}
