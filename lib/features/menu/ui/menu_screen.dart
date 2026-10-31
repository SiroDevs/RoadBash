// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/constants/app_assets.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/brand/scene_preview.dart';
import '../../../common/widgets/retro/page/music_scope.dart';
import '../../../common/widgets/retro/page/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../common/l10n/l10n_extension.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/game/input/tilt/tilt_access.dart';
import '../../../core/game/road/track/road_track.dart';
import '../../../core/layout/responsive_layout_builder.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/scene_id.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_target.dart';
import '../cubit/scene_order.dart';
import 'widgets/menu_fixed_layout.dart';
import 'widgets/menu_grid.dart';
import 'widgets/menu_target_info.dart';
import 'widgets/rider_bar.dart';
import 'widgets/scene_info.dart';

/// Main menu where the player picks a scene or reception.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

/// State for [MenuScreen]; caches the race length of each scene.
class _MenuScreenState extends State<MenuScreen> {
  final Map<SceneId, double> _km = {
    for (final id in SceneId.values) id: RoadTrack.raceKm(id),
  };

  @override
  void initState() {
    super.initState();
    _prepareTilt();
  }

  /// Asks for tilt access early so steering is ready when a race starts.
  void _prepareTilt() {
    final profile = context.read<SettingsCubit>().state.profile;
    unawaited(TiltAccess.instance.prepareFor(profile));
  }

  /// Selects a menu target and opens the scene's race or reception.
  void _open(MenuCubit menu, MenuTarget target) {
    menu.open(target);
    final id = target.scene;
    if (id == null) {
      context.goNamed(RouteNames.reception);
    } else {
      context.goNamed(RouteNames.race, pathParameters: {'scene': id.name});
    }
  }

  /// First tap highlights an entry, a tap on the highlighted entry opens it.
  void _tap(MenuCubit menu, MenuTarget selected, MenuTarget target) {
    _prepareTilt();
    target == selected ? _open(menu, target) : menu.select(target);
  }

  @override
  Widget build(BuildContext context) {
    final menu = context.read<MenuCubit>();
    final cols = MenuGrid.columnsFor(MediaQuery.sizeOf(context).width);
    return MusicScope(
      track: MusicTrack.menu,
      child: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, progress) {
          final order = SceneOrder.from(progress);
          final items = order.items;
          return CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
                  menu.move(-1, items),
              const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
                  menu.move(1, items),
              const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                  menu.move(-cols, items),
              const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                  menu.move(cols, items),
              const SingleActivator(LogicalKeyboardKey.enter): () =>
                  _open(menu, menu.state ?? items.first),
            },
            child: Focus(
              autofocus: true,
              child: BlocBuilder<MenuCubit, MenuTarget?>(
                builder: (context, state) => RetroScaffold(
                  asset: AppAssets.appMain,
                  padding: EdgeInsets.fromLTRB(
                    context.sizes.pad,
                    context.sizes.pad * 0.65,
                    context.sizes.pad,
                    context.sizes.pad * 0.5,
                  ),
                  child: _content(
                    context,
                    menu,
                    order,
                    items.contains(state) ? state! : items.first,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the menu body for the selected target.
  Widget _content(
    BuildContext context,
    MenuCubit menu,
    SceneOrder order,
    MenuTarget selected,
  ) {
    final l10n = context.l10n;
    final sizes = context.sizes;
    final id = selected.scene;
    final info = SceneInfo(scene: id, km: id == null ? 0 : _km[id]!);
    final card = ScenePreview(menuAsset(selected));
    final title = RetroTitle(menuLabel(l10n, selected));
    final entries = MenuGrid(
      order: order,
      selected: selected,
      onTap: (target) => _tap(menu, selected, target),
    );

    final fixed = MenuFixedLayout(
      title: title,
      info: info,
      card: card,
      entries: entries,
    );

    return ResponsiveLayoutBuilder(
      small: (_, __) => ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: sizes.gap),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: sizes.cardMaxW * MenuFixedLayout.cardScale,
                ),
                child: card,
              ),
            ),
            SizedBox(height: sizes.gap),
            info,
            SizedBox(height: sizes.gap),
            const RiderBar(),
            SizedBox(height: sizes.gapSmall),
            entries,
          ],
        ),
      ),
      medium: (_, __) => fixed,
      large: (_, __) => fixed,
    );
  }
}
