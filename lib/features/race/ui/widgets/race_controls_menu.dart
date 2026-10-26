// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/layout/responsive_layout_builder.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../../../common/l10n/l10n_extension.dart';

Future<void> showRaceControlsMenu(BuildContext context) => showDialog<void>(
  context: context,
  barrierColor: Colors.black54,
  builder: (_) => const _RaceControlsDialog(),
);

class _RaceControlsDialog extends StatelessWidget {
  const _RaceControlsDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.sizes;
    final cubit = context.read<SettingsCubit>();
    final maxWidth = context.layoutSize.pick(
      small: double.infinity,
      medium: 460.0,
      large: 500.0,
    );

    return Dialog(
      backgroundColor: const Color(0xF2101020),
      insetPadding: EdgeInsets.all(s.gap),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Retro.orange, width: 2),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final p = state.profile;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        s.gap,
                        s.gap,
                        s.gap,
                        s.gapSmall,
                      ),
                      child: RetroTitle(l10n.controlsTitle, size: s.title * 0.75),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, size: 50),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: s.gap),
                  child: Text(
                    l10n.racePaused,
                    style: retroBody(size: s.caption, color: Retro.dim),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: s.gapSmall),
                    child: Column(
                      children: [
                        _SwitchRow(
                          title: l10n.useScreenTouch,
                          value: p.useScreenTouch,
                          onChanged: cubit.setUseScreenTouch,
                        ),
                        _SwitchRow(
                          title: l10n.muteSound,
                          value: p.mute,
                          onChanged: cubit.setMute,
                        ),
                        _SwitchRow(
                          title: l10n.playMusic,
                          value: p.musicOn,
                          onChanged: cubit.setMusicOn,
                        ),
                        _SwitchRow(
                          title: l10n.soundEffects,
                          value: p.effectsOn,
                          onChanged: cubit.setEffectsOn,
                        ),
                        _SwitchRow(
                          title: l10n.engineSound,
                          value: p.engineOn,
                          onChanged: cubit.setEngineOn,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(s.gap),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RetroButton(
                      l10n.raceResume,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return Semantics(
      toggled: value,
      label: title,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: s.gap,
            vertical: s.gapSmall,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: retroBody(size: s.body))],
                ),
              ),
              SizedBox(width: s.gap),
              Switch(
                value: value,
                onChanged: onChanged,
                thumbColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Retro.ink
                      : Retro.dim,
                ),
                trackColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Retro.orange
                      : Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
