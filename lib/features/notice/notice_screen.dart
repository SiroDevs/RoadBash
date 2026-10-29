// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/constants/app_assets.dart';
import '../../common/l10n/l10n_extension.dart';
import '../../common/layout/retro_sizes.dart';
import '../../common/widgets/retro/page/retro_page.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../../core/router/route_names.dart';
import '../auth/cubit/auth_cubit.dart';

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
    final signedIn = context.read<AuthCubit>().state.isSignedIn;
    context.goNamed(signedIn ? RouteNames.menu : RouteNames.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = context.sizes;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): _continue,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): _continue,
      },
      child: Focus(
        autofocus: true,
        child: RetroPage(
          onTap: _continue,
          asset: AppAssets.appSplash1,
          padding: EdgeInsets.symmetric(horizontal: s.pad, vertical: s.pad * 0.6),
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
                    padding: EdgeInsets.all(s.infoPad),
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: s.gap * 0.6),
                        Text(
                          l10n.noticeTitle,
                          style: retroBody(
                            size: s.noticeTitle,
                            color: Retro.orange,
                          ),
                        ),
                        SizedBox(height: s.noticeGap * 0.55),
                        Text(
                          l10n.noticeFun,
                          style: retroBody(size: s.noticeBody),
                        ),
                        SizedBox(height: s.noticeGap),
                        Text(
                          l10n.noticeWarning,
                          style: retroBody(
                            size: s.noticeBody,
                            color: Retro.red,
                          ),
                        ),
                        SizedBox(height: s.noticeGap),
                      ],
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
