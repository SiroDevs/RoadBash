// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../config/road_config.dart';
import '../../../road_projection.dart';
import '../../../scene_theme.dart';
import '../../prop.dart';
import 'footbridge_painter.dart';
import 'gantry_painter.dart';
import 'overpass_painter.dart';

class SpanPainter {
  SpanPainter(SceneTheme theme)
      : _dual = theme.dualCarriageway,
        _footbridge = FootbridgePainter(theme),
        _gantry = GantryPainter(theme),
        _overpass = OverpassPainter(theme);

  final bool _dual;
  final FootbridgePainter _footbridge;
  final GantryPainter _gantry;
  final OverpassPainter _overpass;

  void draw(Canvas c, VisionSeg v, Prop p, Vector2 size) {
    final overpass = p.kind == PropKind.overpass;
    final reachUnits = overpass ? 1.5 : 1.22;
    var left = v.x1 - v.w1 * reachUnits;
    var right = v.x1 + v.w1 * reachUnits;

    // Footbridges and overpasses cross the whole highway: over the near
    // carriageway, the median and the opposite carriageway, from one verge to
    // the other. A single pier stands in the median.
    double? medianPier;
    double? farPier;
    final crossesAll = (p.kind == PropKind.footbridge || overpass) &&
        _dual &&
        v.seg.section.hasOpposite;
    if (crossesAll) {
      const sh = RoadConfig.shoulder;
      const median = RoadConfig.medianWidth;
      const farEdge = 1 + sh + median + RoadConfig.oppositeWidth + sh;
      // Same overhang past the outer shoulder as on the near side.
      right = v.x1 + v.w1 * (farEdge + (reachUnits - (1 + sh)));
      medianPier = v.x1 + v.w1 * (1 + sh + median / 2);
      farPier = v.x1 + v.w1 * (farEdge + 0.17);
    }
    // An overpass is a road crossing above the highway: its deck runs from
    // the far left of the view to the far right, past both screen edges.
    final spanLeft = left, spanRight = right;
    if (overpass) {
      left = math.min(left, -16.0);
      right = math.max(right, size.x + 16);
    }
    if (right < 0 || left > size.x) return;
    if (p.height * v.k1 < 5) return;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, v.clip));
    switch (p.kind) {
      case PropKind.footbridge:
        _footbridge.draw(c, v, p, left, right, pillarX: medianPier);
      case PropKind.gantry:
        _gantry.draw(c, v, p, left, right);
      case PropKind.overpass:
        _overpass.draw(c, v, p, left, right,
            spanL: spanLeft,
            spanR: spanRight,
            medianPier: medianPier,
            farPier: farPier);
      default:
        break;
    }
    c.restore();
  }
}