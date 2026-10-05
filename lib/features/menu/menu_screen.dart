// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/game/road_theme.dart';
import '../../common/widgets/game/road_track.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../common/widgets/retro/scene_preview.dart';
import '../game/game_settings.dart';

/// Level select: City, Suburbs, Reception. Tap an entry to preview it, tap
/// it again (or press Enter / the button) to go.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  static const _labels = ['City', 'Suburbs', 'Reception'];
  static const _receptionBlurb =
      'Pop in to set your rider name, mix the sound and check the controls.';

  final Map<SceneId, double> _km = {
    for (final id in SceneId.values) id: RoadTrack.raceKm(id),
  };
  int _sel = 0;

  SceneTheme? get _theme => _sel < 2 ? SceneTheme.of(SceneId.values[_sel]) : null;

  void _move(int d) => setState(() => _sel = (_sel + d) % 3);

  void _go() {
    final t = _theme;
    if (t == null) {
      context.goNamed(RouteNames.reception);
    } else {
      context.goNamed(RouteNames.race, pathParameters: {'scene': t.id.name});
    }
  }

  void _tap(int i) => i == _sel ? _go() : setState(() => _sel = i);

  @override
  Widget build(BuildContext context) {
    final t = _theme;
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t?.blurb ?? _receptionBlurb, style: retroBody(size: 22)),
        const SizedBox(height: 16),
        if (t != null)
          Text('Length: ${_km[t.id]!.toStringAsFixed(1)} km, ${t.laps} laps',
              style: retroBody(size: 20, color: Retro.yellow)),
      ],
    );
    final card = t != null
        ? ScenePreview(t)
        : const Icon(Icons.support_agent, size: 120, color: Retro.orange);

    return Scaffold(
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(2),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
          const SingleActivator(LogicalKeyboardKey.enter): _go,
        },
        child: Focus(
          autofocus: true,
          child: RetroBackdrop(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RetroTitle(_labels[_sel]),
                    const SizedBox(height: 12),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, box) => box.maxWidth > 700
                            ? Row(children: [
                                Expanded(child: info),
                                const SizedBox(width: 24),
                                Expanded(child: Center(child: card)),
                              ])
                            : Column(children: [
                                Expanded(child: Center(child: card)),
                                const SizedBox(height: 12),
                                info,
                              ]),
                      ),
                    ),
                    _riderBar(),
                    const SizedBox(height: 8),
                    _options(),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RetroButton(t == null ? 'Enter' : 'Start race', onTap: _go),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _riderBar() => ListenableBuilder(
        listenable: GameSettings.instance,
        builder: (context, _) => Container(
          color: Retro.panel,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(GameSettings.instance.playerName, style: retroBody(size: 22)),
              Text('Level 1', style: retroBody(size: 22)),
            ],
          ),
        ),
      );

  Widget _options() => Container(
        color: Retro.panel,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            for (var i = 0; i < _labels.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => _tap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward,
                            size: 20,
                            color: i == _sel ? Retro.yellow : Colors.transparent),
                        const SizedBox(width: 6),
                        Text(_labels[i],
                            style: retroBody(
                                size: 22,
                                color: i == _sel ? Colors.white : Retro.dim)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
