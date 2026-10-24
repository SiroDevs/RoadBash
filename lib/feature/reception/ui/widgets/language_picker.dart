// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../../core/settings/settings_cubit.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  static const _options = {'en': 'English', 'sw': 'Kiswahili'};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.languageHint, style: retroBody(size: context.sizes.small)),
        SizedBox(height: context.sizes.gap * 0.75),
        for (final entry in _options.entries)
          RetroMenuItem(
            label: entry.value,
            selected: entry.key == current,
            onTap: () => context.read<SettingsCubit>().setLanguage(entry.key),
          ),
      ],
    );
  }
}
