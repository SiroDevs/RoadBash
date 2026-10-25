// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
import '../../../common/widgets/retro/retro_controls.dart';
import '../../../common/widgets/retro/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../common/widgets/retro/scene_preview.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/music_scope.dart';
import '../../../core/game/road/road_config.dart';
import '../../../core/game/road/road_theme.dart';
import '../../../core/game/road/road_track.dart';
import '../../../core/progress/progress_cubit.dart';
import '../../../core/settings/settings_cubit.dart';
import '../../../domain/models/scene_id.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/menu_cubit.dart';
import 'widgets/online_badge.dart';
import 'widgets/scene_info.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Map<SceneId, double> _km = {
    for (final id in SceneId.values)
      id: RoadTrack(id).length * SceneTheme.of(id).laps * RoadConfig.unitKm,
  };

  /// How much of its slot the postcard fills.
  static const double _cardScale = 0.75;

  SceneId _scene(int index) => SceneId.values[index];

  void _go(int index) => context.goNamed(
        RouteNames.race,
        pathParameters: {'scene': _scene(index).name},
      );

  void _reception() => context.goNamed(RouteNames.reception);

  void _tap(MenuCubit menu, int index) =>
      index == menu.state ? _go(index) : menu.select(index);

  @override
  Widget build(BuildContext context) {
    final menu = context.read<MenuCubit>();
    return MusicScope(
      track: MusicTrack.menu,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
              menu.move(MenuCubit.entries - 1),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
              menu.move(1),
          const SingleActivator(LogicalKeyboardKey.enter): () =>
              _go(menu.state),
        },
        child: Focus(
          autofocus: true,
          child: BlocBuilder<MenuCubit, int>(
            builder: (context, index) => RetroScaffold(
              asset: AppAssets.appMain,
              padding: EdgeInsets.fromLTRB(
                context.sizes.pad,
                context.sizes.pad * 0.65,
                context.sizes.pad,
                context.sizes.pad * 0.5,
              ),
              child: _content(context, menu, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, MenuCubit menu, int index) {
    final l10n = context.l10n;
    final s = context.sizes;
    final id = _scene(index);
    final info = SceneInfo(scene: id, km: _km[id]!);
    final card = ScenePreview(switch (id) {
      SceneId.city => AppAssets.sceneCity,
      SceneId.suburbs => AppAssets.sceneSuburbs,
      SceneId.thikaRoad => AppAssets.sceneThikaRoad,
    });

    final title = RetroTitle(_label(l10n, id));
    final entries = Container(
      color: Retro.panel,
      child: Row(
        children: [
          for (var i = 0; i < MenuCubit.entries; i++)
            RetroMenuItem(
              center: true,
              selected: i == index,
              label: _label(l10n, _scene(i)),
              onTap: () => _tap(menu, i),
            ).expanded(),
        ],
      ),
    );
    final go = SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: s.gap * 0.75,
        runSpacing: s.gap * 0.75,
        children: [
          RetroButton(l10n.receptionTitle, onTap: _reception),
          RetroButton(l10n.startRace, onTap: () => _go(index)),
        ],
      ),
    );

    return ResponsiveLayoutBuilder(
      small: (_, __) => ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: s.gap),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: s.cardMaxW * _cardScale),
                child: card,
              ),
            ),
            SizedBox(height: s.gap),
            info,
            SizedBox(height: s.gap),
            _riderBar(context),
            SizedBox(height: s.gapSmall),
            entries,
            SizedBox(height: s.gap),
            go,
          ],
        ),
      ),
      medium: (_, __) => _fixed(context, s, title, info, card, entries, go),
      large: (_, __) => _fixed(context, s, title, info, card, entries, go),
    );
  }

  Widget _fixed(
    BuildContext context,
    RetroSizes s,
    Widget title,
    Widget info,
    Widget card,
    Widget entries,
    Widget go,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: s.gapSmall),
        LayoutBuilder(
          builder: (context, box) => box.maxWidth > 640
              ? Row(
                  children: [
                    SingleChildScrollView(child: info).expanded(),
                    SizedBox(width: s.gap * 1.5),
                    _smaller(card).center().expanded(),
                  ],
                )
              : Column(
                  children: [
                    _smaller(card).center().expanded(),
                    SizedBox(height: s.gapSmall),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: box.maxHeight * 0.45,
                      ),
                      child: SingleChildScrollView(child: info),
                    ),
                  ],
                ),
        ).expanded(),
        SizedBox(height: s.gapSmall),
        _riderBar(context),
        SizedBox(height: s.gapSmall * 0.75),
        entries,
        SizedBox(height: s.gap * 0.6),
        go,
      ],
    );
  }

  Widget _smaller(Widget card) =>
      FractionallySizedBox(widthFactor: _cardScale, child: card);

  String _label(AppLocalizations l10n, SceneId id) => l10n.sceneTitle(id);

  Widget _riderBar(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: Retro.panel,
      padding: EdgeInsets.symmetric(vertical: context.sizes.gapSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, s) => Text(
              s.profile.displayName(l10n),
              style: retroBody(size: context.sizes.body),
            ),
          ),
          BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, p) => Text(
              l10n.levelLabel(p.level),
              style: retroBody(size: context.sizes.body),
            ),
          ),
          const OnlineBadge(),
        ],
      ),
    );
  }
}