// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../common/app_router/route_names.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/auth/auth_cubit.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../l10n/l10n_extension.dart';

class AccountPanel extends StatelessWidget {
  const AccountPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.sizes;
    final session = context.watch<AuthCubit>().state.session;
    final name = session?.name ??
        context.read<SettingsCubit>().state.profile.displayName(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          session == null ? l10n.accountOffline : l10n.accountSignedInAs(name),
          style: retroBody(size: s.body),
        ),
        if (session?.isAdmin ?? false) ...[
          SizedBox(height: s.gapSmall),
          Text(
            l10n.accountAdmin,
            style: retroBody(size: s.small, color: Retro.yellow),
          ),
        ],
        SizedBox(height: s.gap),
        RetroButton(
          l10n.switchPlayer,
          onTap: () {
            final auth = context.read<AuthCubit>();
            context.goNamed(RouteNames.signIn);
            auth.signOut();
          },
        ),
      ],
    );
  }
}
