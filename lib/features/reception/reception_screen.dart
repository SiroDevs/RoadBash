// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/retro/retro_controls.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../l10n/l10n_extension.dart';
import '../audio/audio_catalog.dart';
import '../audio/music_scope.dart';
import 'cubit/reception_cubit.dart';
import 'widgets/name_editor.dart';
import 'widgets/sound_mix.dart';

/// The settings desk: pick an item on the left, edit it on the right.
class ReceptionScreen extends StatelessWidget {
  const ReceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      ReceptionTab.name: l10n.receptionName,
      ReceptionTab.sound: l10n.receptionSound,
      ReceptionTab.controls: l10n.receptionControls,
    };
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        child: BlocBuilder<ReceptionCubit, ReceptionTab>(
          builder: (context, tab) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RetroTitle(l10n.receptionTitle),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final entry in labels.entries)
                            RetroMenuItem(
                              label: entry.value,
                              selected: entry.key == tab,
                              onTap: () =>
                                  context.read<ReceptionCubit>().open(entry.key),
                            ),
                          RetroMenuItem(
                            label: l10n.receptionDone,
                            selected: false,
                            onTap: () => context.goNamed(RouteNames.menu),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Retro.panel,
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(child: _detail(context, tab)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, ReceptionTab tab) => switch (tab) {
        ReceptionTab.name => const NameEditor(),
        ReceptionTab.sound => const SoundMix(),
        ReceptionTab.controls =>
          Text(context.l10n.controlsHelp, style: retroBody()),
      };
}
