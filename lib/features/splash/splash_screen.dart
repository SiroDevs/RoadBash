// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/constants/app_assets.dart';
import '../../common/l10n/l10n_extension.dart';
import '../../common/layout/responsive_scroll_body.dart';
import '../../common/layout/retro_sizes.dart';
import '../../common/widgets/retro/brand/logo_mark.dart';
import '../../common/widgets/retro/page/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/route_names.dart';
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
    final sizes = context.sizes;
    final studio = AppConstants.appCredits.replaceFirst('© ', '');
    return BlocListener<SplashCubit, bool>(
      listener: (context, ready) {
        if (ready) context.goNamed(RouteNames.notice);
      },
      child: RetroScaffold(
        onTap: context.read<SplashCubit>().skip,
        asset: AppAssets.appSplash,
        child: ResponsiveScrollBody(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.splashPresents(studio),
                textAlign: TextAlign.center,
                style: retroBody(size: sizes.presents),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutBack,
                    builder: (_, v, child) => Opacity(
                      opacity: v.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.8 + 0.2 * v,
                        child: child,
                      ),
                    ),
                    child: RoadBashLogo(size: sizes.logo),
                  ),
                  SizedBox(height: sizes.gap),
                  Text(
                    l10n.splashTagline,
                    textAlign: TextAlign.center,
                    style: retroBody(size: sizes.tagline, color: Retro.orange),
                  ),
                ],
              ),
              Text(
                l10n.splashRights(AppConstants.appCredits),
                textAlign: TextAlign.center,
                style: retroBody(size: sizes.rights, color: Retro.dim),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
