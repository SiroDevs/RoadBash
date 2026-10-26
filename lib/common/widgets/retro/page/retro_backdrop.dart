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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A1F), Color(0xFFFFFFFF), Color(0xFF000000)],
        ).createShader(r),
    );
    final stripe = Paint()..color = const Color(0xFFB86918);
    canvas.drawPath(Path()..close(), stripe);
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
