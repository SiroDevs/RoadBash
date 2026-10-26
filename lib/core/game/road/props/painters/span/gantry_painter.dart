// Dart imports:
import 'dart:math' as math;
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Project imports:
import '../../../../../constants/app_constants.dart';
import '../../../../utils/paint_utils.dart';
import '../../../road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../prop.dart';
import '../../zones/thika_zones.dart';

class GantryPainter {
  GantryPainter(SceneTheme theme)
      : _post = fogRamp(theme.poleColor, theme.fog),
        _panel = fogRamp(theme.signGreen, theme.fog),
        _edge = fogRamp(const Color(0xFFF2F2EC), theme.fog);

  final List<Paint> _post, _panel, _edge;

  static const double _textCutoff = 0.55;

  static final Map<String, TextPainter> _labels = {};

  static TextPainter _label(String text) => _labels.putIfAbsent(
        text,
        () => TextPainter(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 64,
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.kFontFamily,
              letterSpacing: 2,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(),
      );

  void draw(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final pw = math.max(1.0, 110 * k);
    final beam = math.max(1.0, 160 * k);

    // Frame
    c.drawRect(Rect.fromLTRB(l - pw, top, l + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(r - pw, top, r + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(l - pw, top, r + pw, top + beam), fogged(_post, f));

    // Sign panel
    final panel = Rect.fromCenter(
      center: Offset(v.x1, top + beam + 400 * k),
      width: (r - l) * 0.62,
      height: 780 * k,
    );
    c.drawRect(panel.inflate(math.max(1.0, 34 * k)), fogged(_edge, f));
    c.drawRect(panel, fogged(_panel, f));

    // Place name
    if (f >= _textCutoff || panel.height < 16) return;
    final tp = _label(thikaSignLabels[p.tint % thikaSignLabels.length]);
    final scale = math.min(
      panel.width * 0.88 / tp.width,
      panel.height * 0.62 / tp.height,
    );
    c.save();
    c.translate(panel.center.dx, panel.center.dy);
    c.scale(scale);
    tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
    c.restore();
  }
}
