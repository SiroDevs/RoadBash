// Flutter imports:
import 'package:flutter/widgets.dart';

/// Tupange's screen pattern: the page scrolls if it cannot fit, but is never
/// shorter than the screen, so `MainAxisAlignment.spaceBetween` and friends
/// still spread the content on tall windows. Nothing is ever clipped.
///
/// Inside, use a plain Column (no Expanded / Spacer, which need a bounded
/// height).
class ResponsiveScrollBody extends StatelessWidget {
  const ResponsiveScrollBody({
    super.key,
    required this.child,
    this.controller,
  });

  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        controller: controller,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}
