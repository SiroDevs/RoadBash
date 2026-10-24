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
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extension.dart';
import '../cubit/menu_cubit.dart';
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

  SceneId? _scene(int index) =>
      index < SceneId.values.length ? SceneId.values[index] : null;

  void _go(int index) {
    final id = _scene(index);
    if (id == null) {
      context.goNamed(RouteNames.reception);
    } else {
      context.goNamed(RouteNames.race, pathParameters: {'scene': id.name});
    }
  }

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
              menu.move(2),
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
    final info = SceneInfo(scene: id, km: id == null ? 0 : _km[id]!);
    String sceneImg = AppAssets.appMain;
    if (id == SceneId.city) {
      sceneImg = AppAssets.sceneCity;
    } else if (id == SceneId.suburbs) {
      sceneImg = AppAssets.sceneSuburbs;
    }
    final card = id == null
        ? ScenePreview(AppAssets.restroom)
        : ScenePreview(sceneImg);

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
    final go = Align(
      alignment: Alignment.centerRight,
      child: RetroButton(
        id == null ? l10n.enterLabel : l10n.startRace,
        onTap: () => _go(index),
      ),
    );

    return ResponsiveLayoutBuilder(
      // Portrait phones and very short windows: everything stacked, scrolls
      // if it has to, nothing is cut off.
      small: (_, __) => ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: s.gap),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: s.cardMaxW),
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

  /// Landscape and desktop: description and postcard side by side, the rest
  /// pinned underneath.
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
                    card.expanded().center(),
                  ],
                )
              : Column(
                  children: [
                    card.expanded().center(),
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

  String _label(AppLocalizations l10n, SceneId? id) =>
      id == null ? l10n.receptionTitle : l10n.sceneTitle(id);

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
        ],
      ),
    );
  }
}
