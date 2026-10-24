// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'responsive_layout_builder.dart';

/// A gap that changes with the layout size. Use [ResponsiveGap.vertical]
/// between rows and [ResponsiveGap.horizontal] between columns.
class ResponsiveGap extends StatelessWidget {
  const ResponsiveGap.vertical({
    super.key,
    this.small = 0,
    this.medium = 0,
    this.large = 0,
  }) : _vertical = true;

  const ResponsiveGap.horizontal({
    super.key,
    this.small = 0,
    this.medium = 0,
    this.large = 0,
  }) : _vertical = false;

  final double small;
  final double medium;
  final double large;
  final bool _vertical;

  @override
  Widget build(BuildContext context) {
    final gap = context.layoutSize.pick(
      small: small,
      medium: medium,
      large: large,
    );
    return _vertical ? SizedBox(height: gap) : SizedBox(width: gap);
  }
}
