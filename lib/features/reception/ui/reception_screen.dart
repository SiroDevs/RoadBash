// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/controls/retro_controls.dart';
import '../../../common/widgets/retro/page/retro_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/layout/responsive_layout_builder.dart';
import '../../../common/constants/app_assets.dart';
import '../../../core/router/route_names.dart';
import '../../suggestions/ui/suggestion_panel.dart';
import '../cubit/reception_cubit.dart';
import 'widgets/account_panel.dart';
import 'widgets/exit_panel.dart';
import 'widgets/language_picker.dart';
import 'widgets/sound_mix.dart';

/// Reception screen with tabs for name, sound, language, stats and more.
class ReceptionScreen extends StatelessWidget {
  const ReceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      ReceptionTab.name: l10n.receptionName,
      ReceptionTab.sound: l10n.receptionSound,
      ReceptionTab.controls: l10n.receptionControls,
      ReceptionTab.language: l10n.languageTitle,
      ReceptionTab.stats: l10n.receptionStats,
      ReceptionTab.leaderboard: l10n.receptionLeaderboard,
      ReceptionTab.suggestions: l10n.receptionSuggestions,
      ReceptionTab.exit: l10n.exitLabel,
    };
    final sizes = context.sizes;
    return RetroPage(
      asset: AppAssets.appMain,
      grayscale: true,
      dim: 0.55,
      child: BlocBuilder<ReceptionCubit, ReceptionTab>(
        builder: (context, tab) {
          final nav = [
            for (final entry in labels.entries)
              RetroMenuItem(
                label: entry.value,
                selected: entry.key == tab,
                onTap: () => _select(context, entry.key),
              ),
            RetroMenuItem(
              label: l10n.receptionDone,
              selected: false,
              onTap: () => context.goNamed(RouteNames.menu),
            ),
          ];
          final title = RetroTitle(l10n.receptionTitle);
          return ResponsiveLayoutBuilder(
            small: (_, __) => ResponsiveScrollBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  SizedBox(height: sizes.gap),
                  ...nav,
                  SizedBox(height: sizes.gap),
                  Container(
                    color: Retro.panel,
                    padding: EdgeInsets.all(sizes.gap),
                    child: _detail(context, tab),
                  ),
                ],
              ),
            ),
            medium: (_, __) => _sideBySide(context, sizes, title, nav, tab),
            large: (_, __) => _sideBySide(context, sizes, title, nav, tab),
          );
        },
      ),
    );
  }

  /// Navigates to stats/leaderboard routes, or opens the tab in place.
  void _select(BuildContext context, ReceptionTab tab) {
    switch (tab) {
      case ReceptionTab.stats:
        context.goNamed(RouteNames.stats);
      case ReceptionTab.leaderboard:
        context.goNamed(RouteNames.leaderboard);
      default:
        context.read<ReceptionCubit>().open(tab);
    }
  }

  /// Lays out the title, tab list and detail panel side by side.
  Widget _sideBySide(
    BuildContext context,
    RetroSizes sizes,
    Widget title,
    List<Widget> nav,
    ReceptionTab tab,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: sizes.gap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nav,
              ),
            ).expanded(flex: 2),
            SizedBox(width: sizes.gap),
            Container(
              color: Retro.panel,
              padding: EdgeInsets.all(sizes.gap),
              child: SingleChildScrollView(child: _detail(context, tab)),
            ).expanded(flex: 3),
          ],
        ).expanded(),
      ],
    );
  }

  /// Returns the panel that matches the selected reception tab.
  Widget _detail(BuildContext context, ReceptionTab tab) => switch (tab) {
    ReceptionTab.name => const AccountPanel(),
    ReceptionTab.sound => const SoundMix(),
    ReceptionTab.language => const LanguagePicker(),
    ReceptionTab.suggestions => const SuggestionPanel(),
    ReceptionTab.stats || ReceptionTab.leaderboard => const SizedBox.shrink(),
    ReceptionTab.exit => const ExitPanel(),
    ReceptionTab.controls => Text(
      context.l10n.controlsHelp,
      style: retroBody(size: context.sizes.small),
    ),
  };
}
