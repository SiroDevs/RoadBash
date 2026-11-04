// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import '../retro_style.dart';

/// Tiny upper-case label, such as ADMIN or PUBLIC.
class RetroTag extends StatelessWidget {
  const RetroTag(this.label, {super.key, this.color = Retro.yellow});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: retroBody(size: context.sizes.caption * 0.8, color: color),
  );
}
