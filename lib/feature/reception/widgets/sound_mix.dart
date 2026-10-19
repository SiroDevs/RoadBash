// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/synth/engine_preview.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../domain/models/engine_flavour.dart';
import '../../../l10n/l10n_extension.dart';

class SoundMix extends StatefulWidget {
  const SoundMix({super.key});

  @override
  State<SoundMix> createState() => _SoundMixState();
}

class _SoundMixState extends State<SoundMix> {
  final _preview = EnginePreview();

  @override
  void dispose() {
    unawaited(_preview.stop());
    super.dispose();
  }

  /// Changes the engine sound and plays a short ride so it can be heard.
  void _pick(EngineFlavour flavour) {
    context.read<SettingsCubit>().setFlavour(flavour);
    _listen(flavour);
  }

  void _listen(EngineFlavour flavour) {
    final p = context.read<SettingsCubit>().state.profile;
    unawaited(_preview.play(flavour, p.master * p.engine));
  }

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
            _flavourPicker(p.flavour),
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

  // TODO(l10n): move the 'Tone' label and flavour names into the .arb files.
  Widget _flavourPicker(EngineFlavour flavour) => Row(
        children: [
          SizedBox(width: 110, child: Text('Tone', style: retroBody(size: 20))),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: Retro.orange,
            onPressed: () => _pick(flavour.previous),
          ),
          Expanded(
            child: Text(
              flavour.label,
              textAlign: TextAlign.center,
              style: retroBody(size: 22, color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: Retro.orange,
            onPressed: () => _pick(flavour.next),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            color: Retro.yellow,
            onPressed: () => _listen(flavour),
          ),
        ],
      );
}
