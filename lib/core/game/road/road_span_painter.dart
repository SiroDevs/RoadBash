// Dart imports:
import 'dart:math' as math;
import 'dart:ui' hide TextStyle;

// Flutter imports:
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../utils/paint_utils.dart';
import 'road_projection.dart';
import 'road_prop.dart';
import 'road_theme.dart';
import 'thika_zones.dart';

/// Draws what crosses the whole carriageway: place-name gantries,
/// footbridges and flyovers. Each is a flat frame pinned to one segment.
class RoadSpanPainter {
  RoadSpanPainter(SceneTheme theme)
      : _concrete = fogRamp(theme.bridgeColor, theme.fog),
        _underside = fogRamp(shade(theme.bridgeColor, -0.32), theme.fog),
        _rail = fogRamp(theme.bridgeRail, theme.fog),
        _post = fogRamp(theme.poleColor, theme.fog),
        _panel = fogRamp(theme.signGreen, theme.fog),
        _edge = fogRamp(const Color(0xFFF2F2EC), theme.fog);

  final List<Paint> _concrete, _underside, _rail, _post, _panel, _edge;
  final Path _path = Path();

  /// Signs far enough away to be a green smudge skip their lettering.
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

  void draw(Canvas c, VisionSeg v, Prop p, Vector2 size) {
    final reach = v.w1 * (p.kind == PropKind.overpass ? 1.5 : 1.22);
    final left = v.x1 - reach, right = v.x1 + reach;
    if (right < 0 || left > size.x) return;
    if (p.height * v.k1 < 5) return;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, v.clip));
    switch (p.kind) {
      case PropKind.footbridge:
        _footbridge(c, v, p, left, right);
      case PropKind.gantry:
        _gantry(c, v, p, left, right);
      case PropKind.overpass:
        _overpass(c, v, p, left, right);
      default:
        break;
    }
    c.restore();
  }

  void _footbridge(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final deck = top + 170 * k;
    final pw = math.max(1.0, 120 * k);
    final stair = 1500 * k;

    // Stairs run outwards from each end of the deck down to the verge.
    _path.reset();
    _path
      ..moveTo(l, deck)
      ..lineTo(l - stair, y)
      ..lineTo(l, y)
      ..close()
      ..moveTo(r, deck)
      ..lineTo(r + stair, y)
      ..lineTo(r, y)
      ..close();
    c.drawPath(_path, fogged(_underside, f));

    c.drawRect(Rect.fromLTRB(l - pw, deck, l + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(r - pw, deck, r + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, top, r + pw * 1.6, deck),
        fogged(_concrete, f));

    // Railing: a top bar over evenly spaced uprights.
    final railTop = top - 250 * k;
    final bar = math.max(1.0, 36 * k);
    c.drawRect(Rect.fromLTRB(l - pw * 1.6, railTop, r + pw * 1.6, railTop + bar),
        fogged(_rail, f));
    final posts = ((r - l) / math.max(6.0, 300 * k)).floor().clamp(2, 28);
    _path.reset();
    for (var n = 0; n <= posts; n++) {
      final x = l + (r - l) * n / posts;
      _path.addRect(Rect.fromLTRB(x - bar * 0.5, railTop, x + bar * 0.5, top));
    }
    c.drawPath(_path, fogged(_rail, f));
  }

  void _gantry(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final pw = math.max(1.0, 110 * k);
    final beam = math.max(1.0, 160 * k);

    c.drawRect(Rect.fromLTRB(l - pw, top, l + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(r - pw, top, r + pw, y + 1), fogged(_post, f));
    c.drawRect(Rect.fromLTRB(l - pw, top, r + pw, top + beam), fogged(_post, f));

    final panel = Rect.fromCenter(
      center: Offset(v.x1, top + beam + 400 * k),
      width: (r - l) * 0.62,
      height: 780 * k,
    );
    c.drawRect(panel.inflate(math.max(1.0, 34 * k)), fogged(_edge, f));
    c.drawRect(panel, fogged(_panel, f));

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

  void _overpass(Canvas c, VisionSeg v, Prop p, double l, double r) {
    final k = v.k1, y = v.y1, f = v.fog;
    final top = y - p.height * k;
    final slab = 560 * k;
    final pier = math.max(1.0, 210 * k);

    for (final x in [v.x1 - v.w1 * 1.3, v.x1 + v.w1 * 1.3]) {
      c.drawRect(Rect.fromLTRB(x - pier, top + slab, x + pier, y + 1),
          fogged(_underside, f));
    }
    c.drawRect(Rect.fromLTRB(l, top, r, top + slab), fogged(_concrete, f));
    c.drawRect(Rect.fromLTRB(l, top + slab * 0.72, r, top + slab),
        fogged(_underside, f));
    c.drawRect(
        Rect.fromLTRB(l, top - 130 * k, r, top), fogged(_rail, f));
  }
}
