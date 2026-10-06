// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../features/game/road/road_theme.dart';
import '../../../features/game/utils/paint_utils.dart';
import '../../../features/game/utils/scenery_shapes.dart';

/// A small postcard of a scene, drawn from the colours the race uses.
class ScenePreview extends StatelessWidget {
  const ScenePreview(this.theme, {super.key});

  final SceneTheme theme;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFEDEDED),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(4, 6))],
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
  final Path _path = Path();

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

    final far = fillPaint(t.backFar);
    if (t.backdrop == BackdropKind.skyline) {
      drawSkyline(canvas,
          width: w, baseY: hz, block: w / 13, minHeight: h * 0.08,
          maxHeight: h * 0.30, scroll: 0, a: far, b: far);
    } else {
      drawHills(canvas, _path,
          width: w, baseY: hz, amplitude: h * 0.07, frequency: 0.03,
          scroll: 0, paint: far);
    }
    canvas.drawRect(Rect.fromLTRB(0, hz, w, h), fillPaint(t.groundLight));
    drawQuad(canvas, _path, fillPaint(t.roadLight), w * 0.47, hz, w * 0.53, hz,
        w * 0.95, h, w * 0.05, h);
    canvas.drawLine(Offset(w / 2, hz), Offset(w / 2, h),
        Paint()..color = t.centerColor..strokeWidth = 3);

    for (final side in const [-1.0, 1.0]) {
      t.decor == DecorKind.buildings
          ? _wall(canvas, w, h, hz, side)
          : _trees(canvas, w, h, hz, side);
    }
  }

  void _wall(Canvas c, double w, double h, double hz, double side) {
    final x = w / 2 + side * w * 0.5;
    drawQuad(c, _path, fillPaint(t.wallColors[side < 0 ? 0 : 1]),
        w / 2 + side * w * 0.06, hz, x, h * 0.88, x, -h * 0.1,
        w / 2 + side * w * 0.06, hz - h * 0.22);
  }

  void _trees(Canvas c, double w, double h, double hz, double side) {
    for (var i = 0; i < 4; i++) {
      final f = (i + 1) / 4;
      final cx = w / 2 + side * w * (0.1 + 0.4 * f * f);
      final cy = hz + (h - hz) * f * f;
      c.drawCircle(Offset(cx, cy - h * 0.1 * f), h * 0.08 * f + 3,
          fillPaint(t.treeDark));
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter old) => old.t != t;
}
