// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/layout/retro_sizes.dart';
import '../../../common/utils/money_util.dart';
import '../../../common/widgets/retro/feedback/retro_skeleton.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../domain/models/race_settlement.dart';
import '../../../l10n/l10n_extension.dart';
import '../../wallet/cubit/wallet_cubit.dart';

/// What the race paid or cost and the wallet balance after it.
class ResultsMoney extends StatelessWidget {
  const ResultsMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final settlement = state.settlement;
        if (state.loading) return _skeleton(context);
        if (settlement == null) return const SizedBox.shrink();
        return _lines(context, settlement);
      },
    );
  }

  /// The prize or crash bills, then the wallet balance.
  Widget _lines(BuildContext context, RaceSettlement settlement) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (settlement.prize > 0)
          _line(context, l10n.resultsPrize(formatMoney(l10n, settlement.prize)), Retro.yellow),
        if (settlement.hospital > 0)
          _line(context, l10n.crashHospital(formatMoney(l10n, settlement.hospital)), Colors.white),
        if (settlement.garage > 0)
          _line(context, l10n.crashGarage(formatMoney(l10n, settlement.garage)), Colors.white),
        _line(
          context,
          l10n.resultsWallet(formatMoney(l10n, settlement.balance)),
          settlement.balance < 0 ? Retro.red : Retro.yellow,
        ),
      ],
    );
  }

  /// One line of text.
  Widget _line(BuildContext context, String text, Color color) => Padding(
    padding: EdgeInsets.only(top: context.sizes.gap * 0.5),
    child: Text(text, style: retroBody(size: context.sizes.body, color: color)),
  );

  /// Shimmering stand-in while the settlement loads.
  Widget _skeleton(BuildContext context) {
    final sizes = context.sizes;
    return RetroShimmer(
      child: Padding(
        padding: EdgeInsets.only(top: sizes.gap * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RetroSkeletonBlock(width: sizes.gap * 12, height: sizes.body),
            SizedBox(height: sizes.gap * 0.5),
            RetroSkeletonBlock(width: sizes.gap * 9, height: sizes.body),
          ],
        ),
      ),
    );
  }
}
