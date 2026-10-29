// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/audio/synth/engine_preview.dart';
import '../../../../domain/models/engine_flavour.dart';
import '../../../settings/cubit/settings_cubit.dart';

/// Reception panel with volume sliders and engine sound selection.
class SoundMix extends StatefulWidget {
  const SoundMix({super.key});

  @override
  State<SoundMix> createState() => _SoundMixState();
}

/// State for [SoundMix]; owns the engine sound preview player.
class _SoundMixState extends State<SoundMix> {
  final _preview = EnginePreview();

  @override
  void dispose() {
    unawaited(_preview.stop());
    super.dispose();
  }

  /// Saves the chosen engine sound and plays a preview.
  void _pick(EngineFlavour flavour) {
    context.read<SettingsCubit>().setFlavour(flavour);
    _listen(flavour);
  }

  /// Plays a short preview of the engine sound at the current volume.
  void _listen(EngineFlavour flavour) {
    final profile = context.read<SettingsCubit>().state.profile;
    unawaited(_preview.play(flavour, profile.masterGain * profile.engine));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final profile = state.profile;
        return Column(
          children: [
            _slider(context, l10n.volumeMaster, profile.master, cubit.setMaster),
            _slider(context, l10n.volumeMusic, profile.music, cubit.setMusic),
            _slider(context, l10n.volumeEngine, profile.engine, cubit.setEngine),
            _slider(context, l10n.volumeEffects, profile.effects, cubit.setEffects),
            _flavourPicker(context, profile.flavour),
          ],
        );
      },
    );
  }

  /// Builds a fixed-width label for a slider row.
  Widget _label(BuildContext context, String text, {Color? color}) {
    final sizes = context.sizes;
    return SizedBox(
      width: sizes.labelW,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 1,
          style: retroBody(size: sizes.small, color: color ?? Colors.white),
        ),
      ),
    );
  }

  /// Builds a labelled slider row.
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
