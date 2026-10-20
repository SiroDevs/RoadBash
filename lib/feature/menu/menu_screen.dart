// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_assets.dart';
import '../../common/widgets/retro/retro_controls.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../common/widgets/retro/scene_preview.dart';
import '../../core/audio/audio_catalog.dart';
import '../../core/audio/music_scope.dart';
import '../../core/game/road/road_config.dart';
import '../../core/game/road/road_theme.dart';
import '../../core/game/road/road_track.dart';
import '../../core/progress/progress_cubit.dart';
import '../../core/settings/settings_cubit.dart';
import '../../domain/models/scene_id.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extension.dart';
import 'cubit/menu_cubit.dart';
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: _content(context, menu, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, MenuCubit menu, int index) {
    final l10n = context.l10n;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RetroTitle(_label(l10n, id)),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, box) => box.maxWidth > 700
              ? Row(
                  children: [
                    info.expanded(),
                    const SizedBox(width: 24),
                    card.expanded().center(),
                  ],
                )
              : Column(children: [card.expanded().center(), info]),
        ).expanded(),
        const SizedBox(height: 8),
        _riderBar(context),
        const SizedBox(height: 6),
        Container(
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
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: RetroButton(
            id == null ? l10n.enterLabel : l10n.startRace,
            onTap: () => _go(index),
          ),
        ),
      ],
    );
  }

  String _label(AppLocalizations l10n, SceneId? id) =>
      id == null ? l10n.receptionTitle : l10n.sceneTitle(id);

  Widget _riderBar(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      color: Retro.panel,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, s) =>
                Text(s.profile.displayName(l10n), style: retroBody(size: 24)),
          ),
          BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, p) =>
                Text(l10n.levelLabel(p.level), style: retroBody(size: 24)),
          ),
        ],
      ),
    );
  }
}
