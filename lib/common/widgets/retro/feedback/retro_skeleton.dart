// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../retro_style.dart';

// Sweeps a shimmer highlight across every skeleton block inside it.
class RetroShimmer extends StatefulWidget {
  const RetroShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<RetroShimmer> createState() => _RetroShimmerState();
}

/// State for [RetroShimmer]; drives the shimmer animation.
class _RetroShimmerState extends State<RetroShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(-1.5 + 3 * _controller.value, 0),
          end: Alignment(-0.5 + 3 * _controller.value, 0),
          colors: [
            Retro.dim.withAlpha(40),
            Retro.dim.withAlpha(110),
            Retro.dim.withAlpha(40),
          ],
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

// A placeholder block; wrap a group of them in [RetroShimmer].
class RetroSkeletonBlock extends StatelessWidget {
  const RetroSkeletonBlock({super.key, this.width, required this.height});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: const ColoredBox(color: Colors.white),
  );
}
