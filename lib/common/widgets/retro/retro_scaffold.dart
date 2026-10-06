// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'retro_backdrop.dart';

/// Backdrop + safe area + padding shared by the menu-style screens.
class RetroScaffold extends StatelessWidget {
  const RetroScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget body = RetroBackdrop(
      child: SafeArea(child: Padding(padding: padding, child: child)),
    );
    if (onTap != null) {
      body = GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: onTap, child: body);
    }
    return Scaffold(body: body);
  }
}
