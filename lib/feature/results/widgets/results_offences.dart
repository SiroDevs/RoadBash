// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../domain/models/traffic_offence.dart';
import '../../../l10n/l10n_extension.dart';

/// The traffic offences the player committed in the race.
class ResultsOffences extends StatelessWidget {
  const ResultsOffences(this.offences, {super.key});

  final Map<TrafficOffence, int> offences;

  @override
  Widget build(BuildContext context) {
    if (offences.isEmpty) return const SizedBox.shrink();
    final sizes = context.sizes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.resultsOffencesTitle,
          style: retroBody(size: sizes.body, color: Retro.red),
        ).padding(top: sizes.gap * 0.75),
        for (final entry in offences.entries)
          Text(
            _label(context, entry.key, entry.value),
            style: retroBody(size: sizes.body, color: Colors.white),
          ).padding(top: sizes.gap * 0.25),
      ],
    );
  }

  /// The line for one kind of offence and how many times it was committed.
  String _label(BuildContext context, TrafficOffence offence, int count) =>
      switch (offence) {
        TrafficOffence.wrongSide => context.l10n.offenceWrongSide(count),
      };
}
