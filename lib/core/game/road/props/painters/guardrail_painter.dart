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

  static const double _detailFog = 0.3;
  static const double _postFog = 0.55;
  static const double _farRailFog = 0.7;

  /// Draws the guardrail between two segments.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final detailed = near.fog < _detailFog;
    // A clamped anchor (prop starts behind the camera) must not grow a post
    // at the wrong place.
    final post = near.seg.index == prop.anchor && near.fog < _postFog;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));
    if (near.fog < _farRailFog) {
      _rail(
        canvas,
        near,
        far,
        GuardrailConfig.farOffset,
        post,
        detailed,
        _farPost,
        size,
      );
    }
    _rail(canvas, near, far, prop.offset, post, detailed, _nearPost, size);
    canvas.restore();
  }

  /// Draws one rail with its posts at a lateral offset.
  ///
  /// [offset] is the rail's lateral position. [post] and [detailed] choose
  /// whether to draw posts and fine detail, [postPaint] holds the fogged post
  /// paints and [size] is the screen size.
  void _rail(
    Canvas canvas,
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
      canvas.drawRect(
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
      canvas.drawPath(_path, fogged(_flat, far.fog));
      return;
    }
    _path.reset();
    _band(near, far, xn, xf, bottom, valleyLo);
    _band(near, far, xn, xf, valleyHi, top);
    canvas.drawPath(_path, fogged(_light, far.fog));
    _path.reset();
    _band(near, far, xn, xf, valleyLo, valleyHi);
    canvas.drawPath(_path, fogged(_dark, far.fog));
  }

  /// Adds a quad for one band of a rail.
  ///
  /// [xn] and [xf] are the near and far x positions and [h0] and [h1] the
  /// bottom and top heights of the band.
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
