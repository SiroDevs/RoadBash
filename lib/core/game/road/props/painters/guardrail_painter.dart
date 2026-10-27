// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../config/guardrail_config.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

/// W-beam guardrails on both edges of the median, as on Thika Road: a
/// corrugated steel beam on posts, nearest rail with square posts, the far
/// rail with round ones.
class GuardrailPainter {
  GuardrailPainter(SceneTheme theme)
    : _light = fogRamp(const Color(0xFFCDD1D6), theme.fog),
      _dark = fogRamp(const Color(0xFF858B93), theme.fog),
      _flat = fogRamp(const Color(0xFFADB2B9), theme.fog),
      _nearPost = fogRamp(const Color(0xFF7A7064), theme.fog),
      _farPost = fogRamp(const Color(0xFFD5D8DC), theme.fog);

  final List<Paint> _light, _dark, _flat, _nearPost, _farPost;
  final Path _path = Path();

  /// Past this fog the corrugation is too small to see: one flat band.
  static const double _detailFog = 0.3;
  static const double _postFog = 0.55;
  static const double _farRailFog = 0.7;

  void draw(Canvas c, VisionSeg near, VisionSeg far, Prop p, Vector2 size) {
    final detailed = near.fog < _detailFog;
    // A clamped anchor (prop starts behind the camera) must not grow a post
    // at the wrong place.
    final post = near.seg.index == p.anchor && near.fog < _postFog;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));
    if (near.fog < _farRailFog) {
      _rail(
        c,
        near,
        far,
        GuardrailConfig.farOffset,
        post,
        detailed,
        _farPost,
        size,
      );
    }
    _rail(c, near, far, p.offset, post, detailed, _nearPost, size);
    c.restore();
  }

  void _rail(
    Canvas c,
    VisionSeg near,
    VisionSeg far,
    double offset,
    bool post,
    bool detailed,
    List<Paint> postPaint,
    Vector2 size,
  ) {
    final xn = near.x1 + near.w1 * offset;
    final xf = far.x1 + far.w1 * offset;
    if (math.max(xn, xf) < 0 || math.min(xn, xf) > size.x) return;

    if (post) {
      final pw = math.max(0.7, GuardrailConfig.postHalfWidth * near.k1);
      c.drawRect(
        Rect.fromLTRB(
          xn - pw,
          near.y1 - GuardrailConfig.beamBottom * near.k1,
          xn + pw,
          near.y1 + 1,
        ),
        fogged(postPaint, near.fog),
      );
    }

    const bottom = GuardrailConfig.beamBottom;
    const valleyLo = GuardrailConfig.valleyBottom;
    const valleyHi = GuardrailConfig.valleyTop;
    const top = GuardrailConfig.beamTop;

    if (!detailed) {
      _path.reset();
      _band(near, far, xn, xf, bottom, top);
      c.drawPath(_path, fogged(_flat, far.fog));
      return;
    }
    _path.reset();
    _band(near, far, xn, xf, bottom, valleyLo);
    _band(near, far, xn, xf, valleyHi, top);
    c.drawPath(_path, fogged(_light, far.fog));
    _path.reset();
    _band(near, far, xn, xf, valleyLo, valleyHi);
    c.drawPath(_path, fogged(_dark, far.fog));
  }

  void _band(
    VisionSeg near,
    VisionSeg far,
    double xn,
    double xf,
    double h0,
    double h1,
  ) {
    addQuad(
      _path,
      xn,
      near.y1 - h0 * near.k1,
      xf,
      far.y1 - h0 * far.k1,
      xf,
      far.y1 - h1 * far.k1,
      xn,
      near.y1 - h1 * near.k1,
    );
  }
}
