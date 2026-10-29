// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../core/constants/app_constants.dart';

// Dimmed full-screen label shown while the race is paused.
class RacePauseOverlay extends StatelessWidget {
  const RacePauseOverlay({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Text(
          context.l10n.racePaused,
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppConstants.displayFont,
            fontSize: context.sizes.title,
          ),
        )
        .alignment(Alignment.center)
        .backgroundColor(Colors.black54)
        .gestures(onTap: onTap);
  }
}
