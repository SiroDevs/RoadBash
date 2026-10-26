// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../road_projection.dart';
import '../../../scene/scene_theme.dart';
import '../../prop.dart';
import 'footbridge_painter.dart';
import 'gantry_painter.dart';
import 'overpass_painter.dart';

class SpanPainter {
  SpanPainter(SceneTheme theme)
      : _footbridge = FootbridgePainter(theme),
        _gantry = GantryPainter(theme),
        _overpass = OverpassPainter(theme);

  final FootbridgePainter _footbridge;
  final GantryPainter _gantry;
  final OverpassPainter _overpass;

  void draw(Canvas c, VisionSeg v, Prop p, Vector2 size) {
    final reach = v.w1 * (p.kind == PropKind.overpass ? 1.5 : 1.22);
    final left = v.x1 - reach, right = v.x1 + reach;
    if (right < 0 || left > size.x) return;
    if (p.height * v.k1 < 5) return;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, v.clip));
    switch (p.kind) {
      case PropKind.footbridge:
        _footbridge.draw(c, v, p, left, right);
      case PropKind.gantry:
        _gantry.draw(c, v, p, left, right);
      case PropKind.overpass:
        _overpass.draw(c, v, p, left, right);
      default:
        break;
    }
    c.restore();
  }
}
