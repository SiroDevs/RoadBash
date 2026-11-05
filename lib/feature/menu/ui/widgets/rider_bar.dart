// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../progress/cubit/progress_cubit.dart';
import '../../../settings/cubit/settings_cubit.dart';
import 'online_badge.dart';
import 'wallet_badge.dart';

/// Rider name, level and online status strip at the bottom of the menu.
class RiderBar extends StatelessWidget {
  const RiderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: Retro.panel,
      padding: EdgeInsets.symmetric(vertical: context.sizes.gapSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _nameAndWallet(context),
          BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, p) => Text(
              l10n.levelLabel(p.level),
              style: retroBody(size: context.sizes.body),
            ),
          ),
          const OnlineBadge(),
        ],
      ),
    );
  }

  /// The rider name with the wallet balance next to it.
  Widget _nameAndWallet(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, s) => Text(
            s.profile.displayName(l10n),
            style: retroBody(size: context.sizes.body),
          ),
        ),
        SizedBox(width: context.sizes.gap),
        const WalletBadge(),
      ],
    );
  }
}
