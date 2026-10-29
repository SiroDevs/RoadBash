// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'touch_hold.dart';

/// Ridge pattern drawn on a pedal.
enum TouchRidges { bars, dots }

/// A labelled pedal button that reports presses.
class TouchPedal extends StatelessWidget {
  const TouchPedal({
    required this.label,
    required this.width,
    required this.height,
    required this.accent,
    required this.icon,
    required this.ridges,
    required this.onChanged,
  });

  final String label;
  final double width, height;
  final Color accent;
  final IconData icon;
  final TouchRidges ridges;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: TouchHold(
        onChanged: onChanged,
        builder: (context, down) => AnimatedScale(
          scale: down ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 70),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.22),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: down
                    ? [accent.withAlpha(235), accent.withAlpha(150)]
                    : const [Color(0xE64A4A55), Color(0xE622222A)],
              ),
              border: Border.all(
                color: down ? Colors.white : accent.withAlpha(200),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(140),
                  blurRadius: down ? 4 : 12,
                  offset: Offset(0, down ? 2 : 6),
                ),
              ],
            ),
            child: CustomPaint(
              painter: TouchRidgePainter(ridges),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: width * 0.34),
                    SizedBox(
                      width: width * 0.86,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the ridge pattern on a pedal.
class TouchRidgePainter extends CustomPainter {
  const TouchRidgePainter(this.kind);

  final TouchRidges kind;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = math.max(1.5, size.width * 0.025)
      ..strokeCap = StrokeCap.round;
    if (kind == TouchRidges.bars) {
      final x0 = size.width * 0.14, x1 = size.width * 0.86;
      for (var i = 1; i <= 6; i++) {
        final rowY = size.height * (0.1 + 0.14 * i);
        if (rowY > size.height * 0.94) break;
        canvas.drawLine(Offset(x0, rowY), Offset(x1, rowY), paint);
      }
    } else {
      final dotRadius = math.max(1.4, size.width * 0.02);
      for (var row = 0; row < 4; row++) {
        for (var col = 0; col < 7; col++) {
          canvas.drawCircle(
            Offset(
              size.width * (0.12 + 0.76 * col / 6),
              size.height * (0.12 + 0.76 * row / 3),
            ),
            dotRadius,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(TouchRidgePainter old) => old.kind != kind;
}
