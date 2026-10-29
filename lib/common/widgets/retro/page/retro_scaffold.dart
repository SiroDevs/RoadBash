// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import 'retro_backdrop.dart';

/// Scaffold that places content over the retro backdrop.
class RetroScaffold extends StatelessWidget {
  const RetroScaffold({
    super.key,
    required this.child,
    this.asset,
    this.grayscale = false,
    this.dim = 0,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final String? asset;
  final bool grayscale;
  final double dim;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget body = RetroBackdrop(
      asset: asset,
      grayscale: grayscale,
      dim: dim,
      child: SafeArea(
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.sizes.pad),
          child: child,
        ),
      ),
    );
    if (onTap != null) {
      body = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: body,
      );
    }
    return Scaffold(body: body);
  }
}