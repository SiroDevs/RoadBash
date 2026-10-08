// Flutter imports:
import 'package:flutter/material.dart';

class RetroBackdrop extends StatelessWidget {
  const RetroBackdrop({super.key, required this.child, this.asset});

  final Widget child;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _BackdropPainter()),
        if (asset != null)
          Image.asset(
            asset!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
    final r = Offset.zero & size;
    canvas.drawRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A1F), Color(0xFF2B2A66), Color(0xFF3B4C9B)],
        ).createShader(r),
    );
    final stripe = Paint()..color = const Color(0x0DFFFFFF);
    final step = size.shortestSide / 6;
    for (var x = -size.height; x < size.width; x += step * 1.6) {
      canvas.drawPath(
        Path()
          ..moveTo(x, size.height)
          ..lineTo(x + step * 0.5, size.height)
          ..lineTo(x + step * 0.5 + size.height, 0)
          ..lineTo(x + size.height, 0)
          ..close(),
        stripe,
      );
    }
    canvas.drawRect(
      r,
      Paint()
        ..shader = const RadialGradient(
          radius: 1.1,
          colors: [Color(0x00000000), Color(0xAA000000)],
        ).createShader(r),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
