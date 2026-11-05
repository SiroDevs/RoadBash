// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/utils/money_util.dart';
import '../../../../common/widgets/retro/feedback/retro_skeleton.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../wallet/cubit/wallet_cubit.dart';

/// The wallet balance next to the rider name; red when in debt.
class WalletBadge extends StatelessWidget {
  const WalletBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final balance = state.balance;
        if (state.loading) return _skeleton(context);
        if (balance == null) return const SizedBox.shrink();
        return _amount(context, balance);
      },
    );
  }

  /// The balance, yellow or red when negative.
  Widget _amount(BuildContext context, int balance) => Text(
    formatMoney(context.l10n, balance),
    style: retroBody(
      size: context.sizes.body,
      color: balance < 0 ? Retro.red : Retro.yellow,
    ),
  );

  /// Shimmering stand-in while the balance loads.
  Widget _skeleton(BuildContext context) => RetroShimmer(
    child: RetroSkeletonBlock(
      width: context.sizes.gap * 7,
      height: context.sizes.body,
    ),
  );
}
