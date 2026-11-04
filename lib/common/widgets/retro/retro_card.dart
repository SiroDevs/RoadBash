// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../layout/retro_sizes.dart';
import 'retro_style.dart';

/// Padded panel with a subtle border and square corners.
class RetroCard extends StatelessWidget {
  const RetroCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child
      .padding(all: context.sizes.gap)
      .decorated(
        color: Retro.panel,
        border: Border.all(color: Retro.dim.withAlpha(90)),
      );
}
