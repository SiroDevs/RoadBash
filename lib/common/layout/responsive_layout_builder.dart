// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app_breakpoints.dart';

/// Layout size handed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  small,
  medium,
  large;

  static ResponsiveLayoutSize fromDimensions(double width, double height) {
    final w = AppBreakpoints.layoutWidth(width, height);
    if (w <= AppBreakpoints.small) return small;
    if (w <= AppBreakpoints.medium) return medium;
    return large;
  }

  static ResponsiveLayoutSize of(Size size) =>
      fromDimensions(size.width, size.height);

  /// Picks one value per tier, e.g. `size.pick(small: 12, medium: 16, large: 24)`.
  T pick<T>({required T small, required T medium, required T large}) =>
      switch (this) {
        ResponsiveLayoutSize.small => small,
        ResponsiveLayoutSize.medium => medium,
        ResponsiveLayoutSize.large => large,
      };
}

typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// Builds a different layout for each size and rebuilds live while the window
/// is resized. The optional [child] is built once per frame and handed to
/// whichever layout wins, so the heavy part is shared between them.
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.small,
    required this.medium,
    required this.large,
    this.child,
  });

  final ResponsiveLayoutWidgetBuilder small;
  final ResponsiveLayoutWidgetBuilder medium;
  final ResponsiveLayoutWidgetBuilder large;
  final Widget Function(ResponsiveLayoutSize currentSize)? child;

  @override
  Widget build(BuildContext context) {
    // The screen size, not the box size, so every part of a screen agrees on
    // the tier.
    final size = ResponsiveLayoutSize.of(MediaQuery.sizeOf(context));
    final shared = child?.call(size);
    return switch (size) {
      ResponsiveLayoutSize.small => small(context, shared),
      ResponsiveLayoutSize.medium => medium(context, shared),
      ResponsiveLayoutSize.large => large(context, shared),
    };
  }
}

extension ResponsiveContext on BuildContext {
  ResponsiveLayoutSize get layoutSize =>
      ResponsiveLayoutSize.of(MediaQuery.sizeOf(this));
}
