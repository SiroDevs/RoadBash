// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../progress/cubit/progress_cubit.dart';
import '../../../settings/cubit/settings_cubit.dart';
import 'online_badge.dart';

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
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, s) => Text(
              s.profile.displayName(l10n),
              style: retroBody(size: context.sizes.body),
            ),
          ),
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
}
