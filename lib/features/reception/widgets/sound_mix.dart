// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/retro/retro_style.dart';
import '../../../l10n/l10n_extension.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../settings/cubit/settings_state.dart';

class SoundMix extends StatelessWidget {
  const SoundMix({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final p = state.profile;
        return Column(
          children: [
            _slider(l10n.volumeMaster, p.master, cubit.setMaster),
            _slider(l10n.volumeMusic, p.music, cubit.setMusic),
            _slider(l10n.volumeEngine, p.engine, cubit.setEngine),
            _slider(l10n.volumeEffects, p.effects, cubit.setEffects),
          ],
        );
      },
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) =>
      Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: retroBody(size: 20))),
          Expanded(
            child: Slider(
              value: value,
              activeColor: Retro.orange,
              onChanged: onChanged,
            ),
          ),
        ],
      );
}
