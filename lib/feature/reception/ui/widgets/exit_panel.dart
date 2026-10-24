// Dart imports:
import 'dart:ui' show AppExitType;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../../common/app_router/route_names.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/strings/controls_strings.dart';
import '../../../../common/widgets/retro/retro_controls.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/utils/app_util.dart';

class ExitPanel extends StatelessWidget {
  const ExitPanel({super.key});

  Future<void> _exit(BuildContext context) async {
    if (kIsWeb) {
      context.goNamed(RouteNames.splash);
    } else if (isDesktop) {
      await ServicesBinding.instance.exitApplication(AppExitType.required);
    } else {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ControlsStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.exitHint, style: retroBody(size: context.sizes.small)),
        SizedBox(height: context.sizes.gap),
        RetroButton(t.exit, onTap: () => _exit(context)),
      ],
    );
  }
}
