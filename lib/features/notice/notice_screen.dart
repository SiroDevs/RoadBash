// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/retro/retro_style.dart';

/// "Ride safe" screen shown once before the menu. Tap anywhere to continue.
class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.goNamed(RouteNames.menu),
        child: RetroBackdrop(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Just a game',
                          style: retroBody(size: 28, color: Retro.yellow)),
                      const SizedBox(height: 12),
                      Text(
                        'RoadBash is made for fun. The races, the pile-ups and '
                        'the stunts are all invented, and none of it shows how '
                        'real riding works.',
                        style: retroBody(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'On real roads, speed and risky riding hurt people: you '
                        'and everyone around you. Race only on a closed track, '
                        'wear full protective gear and ride within your limits. '
                        'Use your head.',
                        style: retroBody(color: Retro.orange),
                      ),
                      const SizedBox(height: 32),
                      Text('Tap to continue',
                          style: retroBody(size: 16, color: Retro.dim)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
