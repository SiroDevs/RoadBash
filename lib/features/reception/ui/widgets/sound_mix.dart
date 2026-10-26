// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/audio/synth/engine_preview.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../../../domain/models/engine_flavour.dart';
import '../../../../common/l10n/l10n_extension.dart';

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

  void _pick(EngineFlavour flavour) {
    context.read<SettingsCubit>().setFlavour(flavour);
    _listen(flavour);
  }

  void _listen(EngineFlavour flavour) {
    final p = context.read<SettingsCubit>().state.profile;
    unawaited(_preview.play(flavour, p.masterGain * p.engine));
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
            _slider(context, l10n.volumeMaster, p.master, cubit.setMaster),
            _slider(context, l10n.volumeMusic, p.music, cubit.setMusic),
            _slider(context, l10n.volumeEngine, p.engine, cubit.setEngine),
            _slider(context, l10n.volumeEffects, p.effects, cubit.setEffects),
            _flavourPicker(context, p.flavour),
          ],
        );
      },
    );
  }

  Widget _label(BuildContext context, String text, {Color? color}) {
    final s = context.sizes;
    return SizedBox(
      width: s.labelW,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 1,
          style: retroBody(size: s.small, color: color ?? Colors.white),
        ),
      ),
    );
  }

  Widget _slider(
    BuildContext context,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) => Row(
    children: [
      _label(context, label),
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
  Widget _flavourPicker(BuildContext context, EngineFlavour flavour) => Row(
    children: [
      _label(context, 'Tone'),
      IconButton(
        icon: const Icon(Icons.chevron_left),
        color: Retro.orange,
        visualDensity: VisualDensity.compact,
        onPressed: () => _pick(flavour.previous),
      ),
      Expanded(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            flavour.label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: retroBody(size: context.sizes.body, color: Colors.white),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.chevron_right),
        color: Retro.orange,
        visualDensity: VisualDensity.compact,
        onPressed: () => _pick(flavour.next),
      ),
      IconButton(
        icon: const Icon(Icons.play_arrow),
        color: Retro.yellow,
        visualDensity: VisualDensity.compact,
        onPressed: () => _listen(flavour),
      ),
    ],
  );
}
