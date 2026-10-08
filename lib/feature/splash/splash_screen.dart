// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_assets.dart';
import '../../common/constants/app_constants.dart';
import '../../common/widgets/retro/logo_mark.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../l10n/l10n_extension.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final studio = AppConstants.appCredits.replaceFirst('© ', '');
    return BlocListener<SplashCubit, bool>(
      listener: (context, ready) {
        if (ready) context.goNamed(RouteNames.notice);
      },
      child: RetroScaffold(
        onTap: context.read<SplashCubit>().skip,
        asset: AppAssets.appSplash,
        child: Column(
          children: [
            Text(l10n.splashPresents(studio), style: retroBody(size: 75)),
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(scale: 0.8 + 0.2 * v, child: child),
              ),
              child: const RoadBashLogo(size: 120),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.splashTagline,
              style: retroBody(size: 50, color: Retro.yellow),
            ),
            const Spacer(),
            Text(
              l10n.splashRights(AppConstants.appCredits),
              style: retroBody(size: 30, color: Retro.dim),
            ),
          ],
        ),
      ),
    );
  }
}
