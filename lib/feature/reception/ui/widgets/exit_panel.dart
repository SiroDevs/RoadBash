// Dart imports:
import 'dart:ui' show AppExitType;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../common/app_router/route_names.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../../core/auth/auth_cubit.dart';
import '../../../../core/utils/app_util.dart';

class ExitPanel extends StatelessWidget {
  const ExitPanel({super.key});

  Future<void> _exit(BuildContext context) async {
    final auth = context.read<AuthCubit>();
    if (kIsWeb) {
      context.goNamed(RouteNames.splash);
      await auth.signOut();
      return;
    }
    await auth.signOut();
    if (isDesktop) {
      await ServicesBinding.instance.exitApplication(AppExitType.required);
    } else {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.exitHint, style: retroBody(size: context.sizes.small)),
        SizedBox(height: context.sizes.gap),
        RetroButton(l10n.exitLabel, onTap: () => _exit(context)),
      ],
    );
  }
}
