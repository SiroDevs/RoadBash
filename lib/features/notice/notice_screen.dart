// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../l10n/l10n_extension.dart';
import '../audio/audio_catalog.dart';
import '../audio/music_scope.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MusicScope(
      track: MusicTrack.menu,
      child: RetroScaffold(
        onTap: () => context.goNamed(RouteNames.menu),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.noticeTitle,
                      style: retroBody(size: 32, color: Retro.yellow)),
                  const SizedBox(height: 12),
                  Text(l10n.noticeFun, style: retroBody()),
                  const SizedBox(height: 24),
                  Text(l10n.noticeWarning,
                      style: retroBody(color: Retro.orange)),
                  const SizedBox(height: 32),
                  Text(l10n.tapToContinue,
                      style: retroBody(size: 18, color: Retro.dim)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
