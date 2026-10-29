// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/layout/responsive_layout_builder.dart';
import '../../../settings/cubit/settings_cubit.dart';

/// Shows the in-race controls dialog.
Future<void> showRaceControlsMenu(BuildContext context) => showDialog<void>(
  context: context,
  barrierColor: Colors.black54,
  builder: (_) => const _RaceControlsDialog(),
);

/// Dialog with sound and steering switches shown during a race.
class _RaceControlsDialog extends StatelessWidget {
  const _RaceControlsDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final cubit = context.read<SettingsCubit>();
    final maxWidth = context.layoutSize.pick(
      small: double.infinity,
      medium: 460.0,
      large: 500.0,
    );

    return Dialog(
      backgroundColor: const Color(0xF2101020),
      insetPadding: EdgeInsets.all(sizes.gap),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Retro.orange, width: 2),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final profile = state.profile;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        sizes.gap,
                        sizes.gap,
                        sizes.gap,
                        sizes.gapSmall,
                      ),
                      child: RetroTitle(l10n.controlsTitle, size: sizes.title * 0.75),
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
                  padding: EdgeInsets.symmetric(horizontal: sizes.gap),
                  child: Text(
                    l10n.racePaused,
                    style: retroBody(size: sizes.caption, color: Retro.dim),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: sizes.gapSmall),
                    child: Column(
                      children: [
                        _SwitchRow(
                          title: l10n.useScreenTouch,
                          value: profile.useScreenTouch,
                          onChanged: cubit.setUseScreenTouch,
                        ),
                        _SwitchRow(
                          title: l10n.muteSound,
                          value: profile.mute,
                          onChanged: cubit.setMute,
                        ),
                        _SwitchRow(
                          title: l10n.playMusic,
                          value: profile.musicOn,
                          onChanged: cubit.setMusicOn,
                        ),
                        _SwitchRow(
                          title: l10n.soundEffects,
                          value: profile.effectsOn,
                          onChanged: cubit.setEffectsOn,
                        ),
                        _SwitchRow(
                          title: l10n.engineSound,
                          value: profile.engineOn,
                          onChanged: cubit.setEngineOn,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(sizes.gap),
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

/// A titled switch row used by the controls dialog.
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
    final sizes = context.sizes;
    return Semantics(
      toggled: value,
      label: title,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.gap,
            vertical: sizes.gapSmall,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: retroBody(size: sizes.body))],
                ),
              ),
              SizedBox(width: sizes.gap),
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
