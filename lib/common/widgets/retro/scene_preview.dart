// Flutter imports:
import 'package:flutter/material.dart';
import 'package:roadbash/common/constants/app_assets.dart';

// Project imports:
import '../../../core/game/road/road_theme.dart';
import '../../../core/game/utils/paint_utils.dart';
import '../../../core/game/utils/scenery_shapes.dart';
import '../../../domain/models/scene_id.dart';

/// A small postcard of a scene
class ScenePreview extends StatelessWidget {
  const ScenePreview(this.sceneId, {super.key});

  final SceneId sceneId;

  @override
  Widget build(BuildContext context) {
    String sceneImg = "";
    if (sceneId == SceneId.city) {
      sceneImg = AppAssets.sceneCity;
    } else if (sceneId == SceneId.city) {
      sceneImg = AppAssets.sceneSuburbs;
    } else {
      sceneImg = AppAssets.appMain;
    }
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFEDEDED),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          // child: CustomPaint(painter: _PreviewPainter(theme)),
          child: Image.asset(sceneImg, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _PreviewPainter extends CustomPainter {
  _PreviewPainter(this.theme);

  final SceneTheme theme;
  final Path _path = Path();

  @override
  void paint(Canvas canva, Size s) {
    final w = s.width, h = s.height, hz = h * 0.45;
    final r = Offset.zero & s;
    canva.clipRect(r);
    canva.drawRect(
      r,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.skyTop, theme.skyHorizon],
        ).createShader(Rect.fromLTWH(0, 0, w, hz)),
    );

    final far = fillPaint(theme.backFar);
    if (theme.backdrop == BackdropKind.skyline) {
      drawSkyline(
        canva,
        width: w,
        baseY: hz,
        block: w / 13,
        minHeight: h * 0.08,
        maxHeight: h * 0.30,
        scroll: 0,
        a: far,
        b: far,
      );
    } else {
      drawHills(
        canva,
        _path,
        width: w,
        baseY: hz,
        amplitude: h * 0.07,
        frequency: 0.03,
        scroll: 0,
        paint: far,
      );
    }
    canva.drawRect(Rect.fromLTRB(0, hz, w, h), fillPaint(theme.ground));
    drawQuad(
      canva,
      _path,
      fillPaint(theme.roadLight),
      w * 0.47,
      hz,
      w * 0.53,
      hz,
      w * 0.95,
      h,
      w * 0.05,
      h,
    );
    canva.drawLine(
      Offset(w / 2, hz),
      Offset(w / 2, h),
      Paint()
        ..color = theme.centerColor
        ..strokeWidth = 3,
    );

    for (final side in const [-1.0, 1.0]) {
      theme.decor == DecorKind.buildings
          ? _wall(canva, w, h, hz, side)
          : _trees(canva, w, h, hz, side);
    }
  }

  void _wall(
    Canvas canva,
    double width,
    double height,
    double hz,
    double side,
  ) {
    final x = width / 2 + side * width * 0.5;
    drawQuad(
      canva,
      _path,
      fillPaint(theme.wallColors[side < 0 ? 0 : 1]),
      width / 2 + side * width * 0.06,
      hz,
      x,
      height * 0.88,
      x,
      -height * 0.1,
      width / 2 + side * width * 0.06,
      hz - height * 0.22,
    );
  }

  void _trees(Canvas c, double w, double h, double hz, double side) {
    for (var i = 0; i < 4; i++) {
      final f = (i + 1) / 4;
      final cx = w / 2 + side * w * (0.1 + 0.4 * f * f);
      final cy = hz + (h - hz) * f * f;
      c.drawCircle(
        Offset(cx, cy - h * 0.1 * f),
        h * 0.08 * f + 3,
        fillPaint(theme.treeDark),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter old) => old.theme != theme;
}
