// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/app_router/route_names.dart';
import '../../../common/constants/app_assets.dart';
import '../../../common/layout/responsive_layout_builder.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/strings/controls_strings.dart';
import '../../../common/widgets/retro/retro_controls.dart';
import '../../../common/widgets/retro/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/music_scope.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/reception_cubit.dart';
import 'widgets/name_editor.dart';
import 'widgets/sound_mix.dart';

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
    final s = context.sizes;
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        asset: AppAssets.appMain,
        child: BlocBuilder<ReceptionCubit, ReceptionTab>(
          builder: (context, tab) {
            final nav = [
              for (final entry in labels.entries)
                RetroMenuItem(
                  label: entry.value,
                  selected: entry.key == tab,
                  onTap: () => context.read<ReceptionCubit>().open(entry.key),
                ),
              RetroMenuItem(
                label: l10n.receptionDone,
                selected: false,
                onTap: () => context.goNamed(RouteNames.menu),
              ),
            ];
            final title = RetroTitle(l10n.receptionTitle);
            return ResponsiveLayoutBuilder(
              // Phones in portrait and short windows: menu on top, details
              // below, the whole page scrolls.
              small: (_, __) => ResponsiveScrollBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    SizedBox(height: s.gap),
                    ...nav,
                    SizedBox(height: s.gap),
                    Container(
                      color: Retro.panel,
                      padding: EdgeInsets.all(s.gap),
                      child: _detail(context, tab),
                    ),
                  ],
                ),
              ),
              medium: (_, __) => _sideBySide(context, s, title, nav, tab),
              large: (_, __) => _sideBySide(context, s, title, nav, tab),
            );
          },
        ),
      ),
    );
  }

  Widget _sideBySide(
    BuildContext context,
    RetroSizes s,
    Widget title,
    List<Widget> nav,
    ReceptionTab tab,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: s.gap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nav,
            ).expanded(flex: 2),
            SizedBox(width: s.gap),
            Container(
              color: Retro.panel,
              padding: EdgeInsets.all(s.gap),
              child: SingleChildScrollView(child: _detail(context, tab)),
            ).expanded(flex: 3),
          ],
        ).expanded(),
      ],
    );
  }

  Widget _detail(BuildContext context, ReceptionTab tab) => switch (tab) {
    ReceptionTab.name => const NameEditor(),
    ReceptionTab.sound => const SoundMix(),
    ReceptionTab.controls => Text(
      _controlsHelp(context),
      style: retroBody(size: context.sizes.small),
    ),
  };

  /// The keyboard paragraphs from the l10n text, followed by the up-to-date
  /// touch paragraph (the l10n one still describes the old arrow layout).
  String _controlsHelp(BuildContext context) {
    final parts = context.l10n.controlsHelp.split('\n\n');
    if (parts.length > 2) parts.removeLast();
    parts.add(ControlsStrings.of(context).touchHelp);
    return parts.join('\n\n');
  }
}
