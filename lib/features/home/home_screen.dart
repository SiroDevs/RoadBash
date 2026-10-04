import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/road_game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Created once. (Creating it inside build() would restart the game on
  // every rebuild.)
  late final RoadGame _game = RoadGame();

  Widget _zone({
    required int flex,
    required IconData icon,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return Expanded(
      flex: flex,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => onDown(),
        onPointerUp: (_) => onUp(),
        onPointerCancel: (_) => onUp(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Icon(icon, size: 48, color: Colors.white24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned.fill(
            child: Row(
              children: [
                _zone(
                  flex: 4,
                  icon: Icons.chevron_left,
                  onDown: () => _game.setTouchSteer(-1),
                  onUp: () => _game.setTouchSteer(0),
                ),
                _zone(
                  flex: 2,
                  icon: Icons.pan_tool_alt_outlined,
                  onDown: () => _game.setTouchBrake(true),
                  onUp: () => _game.setTouchBrake(false),
                ),
                _zone(
                  flex: 4,
                  icon: Icons.chevron_right,
                  onDown: () => _game.setTouchSteer(1),
                  onUp: () => _game.setTouchSteer(0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
