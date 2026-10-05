// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../game/road_projection.dart';
import '../game/road_theme.dart';

/// A little "postcard" of a scene, drawn from the same theme colours the
/// race uses, for the menu.
class ScenePreview extends StatelessWidget {
  const ScenePreview(this.theme, {super.key});

  final SceneTheme theme;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(4, 6))],
        ),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: CustomPaint(painter: _PreviewPainter(theme)),
        ),
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  _PreviewPainter(this.t);

  final SceneTheme t;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height, hz = h * 0.45;
    final r = Offset.zero & s;
    canvas.clipRect(r);
    canvas.drawRect(
        r,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [t.skyTop, t.skyHorizon],
          ).createShader(Rect.fromLTWH(0, 0, w, hz)));

    final far = Paint()..color = t.backFar;
    if (t.backdrop == BackdropKind.skyline) {
      for (var i = 0; i < 14; i++) {
        final bh = h * (0.08 + 0.22 * roadRand(i));
        canvas.drawRect(Rect.fromLTWH(i * w / 13, hz - bh, w / 13 + 1, bh), far);
      }
    } else {
      final p = Path()..moveTo(0, hz);
      for (double x = 0; x <= w; x += 6) {
        p.lineTo(x, hz - h * 0.12 * (1 + math.sin(x * 0.03)));
      }
      canvas.drawPath(p..lineTo(w, hz)..close(), far);
    }
    canvas.drawRect(Rect.fromLTRB(0, hz, w, h), Paint()..color = t.groundLight);

    final road = Path()
      ..moveTo(w * 0.47, hz)
      ..lineTo(w * 0.53, hz)
      ..lineTo(w * 0.95, h)
      ..lineTo(w * 0.05, h)
      ..close();
    canvas.drawPath(road, Paint()..color = t.roadLight);
    canvas.drawLine(Offset(w / 2, hz), Offset(w / 2, h),
        Paint()..color = t.centerColor..strokeWidth = 3);

    for (final side in const [-1.0, 1.0]) {
      if (t.decor == DecorKind.buildings) {
        final x = w / 2 + side * w * 0.5;
        final q = Path()
          ..moveTo(w / 2 + side * w * 0.06, hz)
          ..lineTo(x, h * 0.88)
          ..lineTo(x, -h * 0.1)
          ..lineTo(w / 2 + side * w * 0.06, hz - h * 0.22)
          ..close();
        canvas.drawPath(q, Paint()..color = t.wallColors[side < 0 ? 0 : 1]);
      } else {
        for (var i = 0; i < 4; i++) {
          final f = (i + 1) / 4;
          final cx = w / 2 + side * w * (0.1 + 0.4 * f * f);
          final cy = hz + (h - hz) * f * f;
          canvas.drawCircle(Offset(cx, cy - h * 0.1 * f), h * 0.08 * f + 3, Paint()..color = t.treeDark);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter old) => old.t != t;
}
