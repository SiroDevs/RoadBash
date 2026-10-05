// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_constants.dart';
import '../../common/widgets/retro/logo_mark.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../game/game_settings.dart';

/// Title screen: studio line, logo, tagline, copyright. Tap to skip.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    GameSettings.instance.load();
    _timer = Timer(const Duration(seconds: 3), _next);
  }

  void _next() {
    _timer?.cancel();
    if (!mounted) return;
    context.goNamed(RouteNames.notice);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _next,
        child: RetroBackdrop(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('${AppConstants.appCredits.replaceFirst('© ', '')} presents',
                      style: retroBody(size: 22)),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                    builder: (_, v, child) =>
                        Opacity(opacity: v.clamp(0.0, 1.0), child: Transform.scale(scale: 0.8 + 0.2 * v, child: child)),
                    child: const RoadBashLogo(size: 72),
                  ),
                  const SizedBox(height: 16),
                  Text(AppConstants.appTagline, style: retroBody(size: 20, color: Retro.yellow)),
                  const Spacer(),
                  Text('${AppConstants.appCredits}. All rights reserved.',
                      style: retroBody(size: 14, color: Retro.dim)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
