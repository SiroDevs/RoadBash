// Flutter imports:
import 'package:flutter/material.dart';

/// Colours shared by the retro-styled screens.
class Retro {
  Retro._();

  static const orange = Color(0xFFF07B3F);
  static const yellow = Color(0xFFFFE066);
  static const dim = Color(0xFFB9B9C9);
  static const panel = Color(0xAA101020);
  static const ink = Color(0xFF0A0A1F);
}

/// Dark indigo backdrop with speed stripes. To use your own artwork, pass
/// [asset] (e.g. 'assets/images/menu.jpg'); it falls back to the gradient
/// when the file is missing.
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
          Image.asset(asset!, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink()),
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
      final p = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + step * 0.5, size.height)
        ..lineTo(x + step * 0.5 + size.height, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(p, stripe);
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

/// Big orange heading with a hard drop shadow.
class RetroTitle extends StatelessWidget {
  const RetroTitle(this.text, {super.key, this.size = 52});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Retro.orange,
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: -1,
        height: 1,
        shadows: const [Shadow(color: Colors.black, offset: Offset(4, 4))],
      ),
    );
  }
}

/// Plain light text with a soft shadow, for reading over busy backgrounds.
TextStyle retroBody({double size = 20, Color color = Colors.white}) =>
    TextStyle(
      color: color,
      fontSize: size,
      height: 1.25,
      shadows: const [
        Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1.5, 1.5)),
      ],
    );

/// Pill button in the orange used by the titles.
class RetroButton extends StatelessWidget {
  const RetroButton(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: Retro.orange,
        foregroundColor: Retro.ink,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
      child: Text(label.toUpperCase()),
    );
  }
}
