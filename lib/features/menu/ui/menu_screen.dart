// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/constants/app_assets.dart';
import '../../../common/l10n/l10n_extension.dart';
import '../../../common/layout/responsive_scroll_body.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/page/music_scope.dart';
import '../../../common/widgets/retro/page/retro_scaffold.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/audio/audio_catalog.dart';
import '../../../core/game/road/track/road_track.dart';
import '../../../core/layout/responsive_layout_builder.dart';
import '../../../core/router/route_names.dart';
import '../../../domain/models/scene_id.dart';
import '../../progress/cubit/progress_cubit.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_target.dart';
import '../cubit/scene_order.dart';
import 'widgets/rider_bar.dart';
import 'widgets/scene_info.dart';
import 'widgets/scene_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Map<SceneId, double> _km = {
    for (final id in SceneId.values) id: RoadTrack.raceKm(id),
  };

  /// Columns of the grid as last laid out, for the up/down arrow keys.
  int _columns = 5;

  /// 5 across on a laptop, 3 on wide phones and tablets, 2 on a phone.
  static int _columnsFor(double width) =>
      width >= 840 ? 5 : (width >= 520 ? 3 : 2);

  void _open(MenuCubit menu, MenuTarget target) {
    menu.open(target);
    final id = target.scene;
    if (id == null) {
      context.goNamed(RouteNames.reception);
    } else {
      context.goNamed(RouteNames.race, pathParameters: {'scene': id.name});
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = context.read<MenuCubit>();
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
                  menu.move(-_columns, items),
              const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                  menu.move(_columns, items),
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

  Widget _content(
    BuildContext context,
    MenuCubit menu,
    SceneOrder order,
    MenuTarget selected,
  ) {
    final l10n = context.l10n;
    final s = context.sizes;
    final id = selected.scene;
    final title = RetroTitle(
      id == null ? l10n.receptionTitle : l10n.sceneTitle(id),
    );
    final grid = _grid(context, menu, order, selected);
    final info = SceneInfo(scene: id, km: id == null ? 0 : _km[id]!);

    return ResponsiveLayoutBuilder(
      small: (_, __) => ResponsiveScrollBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: s.gap),
            grid,
            SizedBox(height: s.gap),
            info,
            SizedBox(height: s.gap),
            const RiderBar(),
          ],
        ),
      ),
      medium: (_, __) => _fixed(s, title, grid, info),
      large: (_, __) => _fixed(s, title, grid, info),
    );
  }

  Widget _fixed(RetroSizes s, Widget title, Widget grid, Widget info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(height: s.gapSmall),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [grid, SizedBox(height: s.gap), info],
          ),
        ).expanded(),
        SizedBox(height: s.gapSmall),
        const RiderBar(),
      ],
    );
  }

  Widget _grid(
    BuildContext context,
    MenuCubit menu,
    SceneOrder order,
    MenuTarget selected,
  ) {
    final l10n = context.l10n;
    final gap = context.sizes.gap;
    return LayoutBuilder(
      builder: (context, box) {
        final cols = _columns = _columnsFor(box.maxWidth);
        final width = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in order.items)
              SizedBox(
                width: width,
                child: SceneTile(
                  image: menuAsset(item),
                  label: item.isReception
                      ? l10n.receptionTitle
                      : l10n.sceneTitle(item.scene!),
                  selected: item == selected,
                  mostPlayed: !item.isReception && item.scene == order.mostPlayed,
                  onTap: () => _open(menu, item),
                  onHighlight: () => menu.select(item),
                ),
              ),
          ],
        );
      },
    );
  }
}
