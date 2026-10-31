// Dart imports:
import 'dart:async';

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
import '../../core/game/input/tilt/tilt_access.dart';
import '../../core/router/route_names.dart';
import '../auth/cubit/auth_cubit.dart';
import '../settings/cubit/settings_cubit.dart';

/// Notice screen with scrolling text shown before sign-in.
class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

/// State for [NoticeScreen]; owns the auto-scroll animation.
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

  /// Scrolls the notice text upward at a steady speed.
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

  /// Leaves the notice screen once, to the menu or sign-in.
  ///
  /// Also asks for tilt access, because a tap is when browsers allow it.
  void _continue() {
    if (!mounted || _left) return;
    _left = true;
    final profile = context.read<SettingsCubit>().state.profile;
    unawaited(TiltAccess.instance.prepareFor(profile));
    final signedIn = context.read<AuthCubit>().state.isSignedIn;
    context.goNamed(signedIn ? RouteNames.menu : RouteNames.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizes = context.sizes;
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
          padding: EdgeInsets.symmetric(horizontal: sizes.pad, vertical: sizes.pad * 0.6),
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
                    padding: EdgeInsets.all(sizes.infoPad),
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: sizes.gap * 0.6),
                        Text(
                          l10n.noticeTitle,
                          style: retroBody(
                            size: sizes.noticeTitle,
                            color: Retro.orange,
                          ),
                        ),
                        SizedBox(height: sizes.noticeGap * 0.55),
                        Text(
                          l10n.noticeFun,
                          style: retroBody(size: sizes.noticeBody),
                        ),
                        SizedBox(height: sizes.noticeGap),
                        Text(
                          l10n.noticeWarning,
                          style: retroBody(
                            size: sizes.noticeBody,
                            color: Retro.red,
                          ),
                        ),
                        SizedBox(height: sizes.noticeGap),
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
