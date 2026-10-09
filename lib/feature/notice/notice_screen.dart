// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_assets.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../l10n/l10n_extension.dart';
import '../../core/audio/audio_catalog.dart';
import '../../core/audio/music_scope.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        onTap: () => context.goNamed(RouteNames.menu),
        asset: AppAssets.appSplash1,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.noticeTitle,
                    style: retroBody(size: 65, color: Retro.yellow),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.noticeFun, style: retroBody(size: 40)),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noticeWarning,
                    style: retroBody(size: 40, color: Retro.orange),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
