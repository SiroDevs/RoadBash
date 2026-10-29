// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app_breakpoints.dart';

enum ResponsiveLayoutSize {
  small,
  medium,
  large;

  static ResponsiveLayoutSize fromDimensions(double width, double height) {
    final layoutWidth = AppBreakpoints.layoutWidth(width, height);
    if (layoutWidth <= AppBreakpoints.small) return small;
    if (layoutWidth <= AppBreakpoints.medium) return medium;
    return large;
  }

  static ResponsiveLayoutSize of(Size size) =>
      fromDimensions(size.width, size.height);

  T pick<T>({required T small, required T medium, required T large}) =>
      switch (this) {
        ResponsiveLayoutSize.small => small,
        ResponsiveLayoutSize.medium => medium,
        ResponsiveLayoutSize.large => large,
      };
}

typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

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
