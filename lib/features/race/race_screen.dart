// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/game/road_theme.dart';
import '../game/race_result.dart';
import '../game/road_game.dart';

/// Hosts the race plus the touch zones: left / right half steers, the middle
/// strip brakes. Throttle is automatic.
class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, required this.scene});

  final SceneId scene;

  @override
  State<RaceScreen> createState() => RaceScreenState();
}

class RaceScreenState extends State<RaceScreen> {
  late final RoadGame _game =
      RoadGame(scene: widget.scene, onFinished: _onFinished);

  void _onFinished(RaceResult result) {
    if (!mounted) return;
    context.goNamed(RouteNames.results, extra: result);
  }

  @override
  void dispose() {
    _game.shutdown();
    super.dispose();
  }

  Widget _zone(int flex, IconData icon, VoidCallback down, VoidCallback up) {
    return Expanded(
      flex: flex,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => down(),
        onPointerUp: (_) => up(),
        onPointerCancel: (_) => up(),
        child: Align(
          alignment: const Alignment(0, 0.45),
          child: Icon(icon, size: 48, color: Colors.white24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned.fill(
            child: Row(
              children: [
                _zone(4, Icons.chevron_left, () => _game.setTouchSteer(-1),
                    () => _game.setTouchSteer(0)),
                _zone(2, Icons.pan_tool_alt_outlined,
                    () => _game.setTouchBrake(true),
                    () => _game.setTouchBrake(false)),
                _zone(4, Icons.chevron_right, () => _game.setTouchSteer(1),
                    () => _game.setTouchSteer(0)),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => context.goNamed(RouteNames.menu),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
