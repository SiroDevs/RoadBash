// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/constants/app_assets.dart';
import '../../common/widgets/retro/retro_scaffold.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/audio/audio_catalog.dart';
import '../../core/audio/music_scope.dart';
import '../../l10n/l10n_extension.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  static const double _speed = 30;

  final ScrollController _scroll = ScrollController();
  bool _left = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _rise());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _rise() async {
    if (!mounted || !_scroll.hasClients) return;
    final end = _scroll.position.maxScrollExtent;
    await _scroll.animateTo(
      end,
      duration: Duration(milliseconds: (end / _speed * 1000).round()),
      curve: Curves.linear,
    );
    _continue();
  }

  void _continue() {
    if (!mounted || _left) return;
    _left = true;
    context.goNamed(RouteNames.menu);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MusicScope(
      track: MusicTrack.menu,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter): _continue,
          const SingleActivator(LogicalKeyboardKey.numpadEnter): _continue,
        },
        child: Focus(
          autofocus: true,
          child: RetroScaffold(
            onTap: _continue,
            asset: AppAssets.appSplash1,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                controller: _scroll,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: box.maxHeight / 2,
                  bottom: box.maxHeight,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0x99000000),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            l10n.noticeTitle,
                            style: retroBody(size: 65, color: Retro.orange),
                          ),
                          const SizedBox(height: 40),
                          Text(l10n.noticeFun, style: retroBody(size: 40)),
                          const SizedBox(height: 75),
                          Text(
                            l10n.noticeWarning,
                            style: retroBody(size: 40, color: Retro.red),
                          ),
                          const SizedBox(height: 75),
                        ],
                      ),
                    ),
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
