// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../retro_grayscale.dart';

class RetroBackdrop extends StatelessWidget {
  const RetroBackdrop({
    super.key,
    required this.child,
    this.asset,
    this.grayscale = false,
    this.dim = 0,
  });

  final Widget child;
  final String? asset;

  final bool grayscale;

  final double dim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _BackdropPainter()),
        if (asset != null)
          grayscaleIf(
            grayscale,
            Image.asset(
              asset!,
              fit: BoxFit.cover,
              color: Color.fromRGBO(0, 0, 0, dim),
              colorBlendMode: BlendMode.srcOver,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        child,
      ],
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A1F), Color(0xFFFFFFFF), Color(0xFF000000)],
        ).createShader(rect),
    );
    final stripe = Paint()..color = const Color(0xFFB86918);
    canvas.drawPath(Path()..close(), stripe);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          radius: 1.1,
          colors: [Color(0x00000000), Color(0xAA000000)],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}