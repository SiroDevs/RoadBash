// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../common/layout/responsive_layout_builder.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/strings/controls_strings.dart';
import '../../../../common/widgets/retro/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/settings/settings_cubit.dart';

/// Opens the controls menu. The caller pauses the race first and resumes it
/// when the returned future completes.
Future<void> showRaceControlsMenu(BuildContext context) => showDialog<void>(
  context: context,
  barrierColor: Colors.black54,
  builder: (_) => const _RaceControlsDialog(),
);

class _RaceControlsDialog extends StatelessWidget {
  const _RaceControlsDialog();

  @override
  Widget build(BuildContext context) {
    final t = ControlsStrings.of(context);
    final s = context.sizes;
    final cubit = context.read<SettingsCubit>();
    // Same idea as Tupange's AppDialog: nearly the whole screen when small, a
    // fixed width otherwise. The rows scroll if the window is short.
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
                Padding(
                  padding: EdgeInsets.fromLTRB(s.gap, s.gap, s.gap, s.gapSmall),
                  child: RetroTitle(t.title, size: s.title * 0.75),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: s.gap),
                  child: Text(
                    t.paused,
                    style: retroBody(size: s.caption, color: Retro.dim),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: s.gapSmall),
                    child: Column(
                      children: [
                        _SwitchRow(
                          title: t.useScreenTouch,
                          subtitle: t.useScreenTouchHint,
                          value: p.useScreenTouch,
                          onChanged: cubit.setUseScreenTouch,
                        ),
                        _SwitchRow(
                          title: t.muteSound,
                          value: p.mute,
                          onChanged: cubit.setMute,
                        ),
                        _SwitchRow(
                          title: t.playMusic,
                          value: p.musicOn,
                          onChanged: cubit.setMusicOn,
                        ),
                        _SwitchRow(
                          title: t.soundEffects,
                          value: p.effectsOn,
                          onChanged: cubit.setEffectsOn,
                        ),
                        _SwitchRow(
                          title: t.engineSound,
                          value: p.engineOn,
                          onChanged: cubit.setEngineOn,
                        ),
                        _SwitchRow(
                          title: t.invertTilt,
                          subtitle: t.invertTiltHint,
                          value: p.invertTilt,
                          onChanged: cubit.setInvertTilt,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(s.gap),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RetroButton(
                      t.resume,
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
    this.subtitle,
  });

  final String title;
  final String? subtitle;
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
                  children: [
                    Text(title, style: retroBody(size: s.body)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: retroBody(size: s.caption, color: Retro.dim),
                      ),
                  ],
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
