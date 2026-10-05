// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../game/race_result.dart';

/// Top three finishers, plus your own row when you finished lower.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.result});

  final RaceResult result;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ...result.rows.take(3),
      if (result.player.place > 3) result.player,
    ];
    return Scaffold(
      body: RetroBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RetroTitle('Race Results'),
                const SizedBox(height: 24),
                for (final r in rows) _row(r),
                const Spacer(),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    RetroButton('Race again', onTap: () => context.goNamed(
                          RouteNames.race,
                          pathParameters: {'scene': result.scene.name},
                        )),
                    RetroButton('Menu', onTap: () => context.goNamed(RouteNames.menu)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(ResultRow r) {
    final style = TextStyle(
      fontFamily: 'monospace',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: r.isPlayer ? Retro.yellow : Colors.white,
      shadows: const [Shadow(color: Colors.black, offset: Offset(2, 2))],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text('${r.place})', style: style)),
          SizedBox(width: 120, child: Text(formatTime(r.seconds), style: style)),
          Expanded(child: Text(r.name, style: style, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
