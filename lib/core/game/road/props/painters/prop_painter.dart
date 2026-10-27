// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';
import 'building_painter.dart';
import 'slip_road_painter.dart';
import 'span/span_painter.dart';
import 'street_furniture_painter.dart';
import 'tree_painter.dart';
import 'tunnel_painter.dart';
import 'wall_painter.dart';

class PropPainter {
  PropPainter(SceneTheme theme)
      : _buildings = BuildingPainter(theme),
        _trees = TreePainter(theme),
        _furniture = StreetFurniturePainter(theme),
        _span = SpanPainter(theme),
        _walls = WallPainter(theme),
        _slipRoads = SlipRoadPainter(theme),
        _tunnels = TunnelPainter(theme);

  final BuildingPainter _buildings;
  final TreePainter _trees;
  final StreetFurniturePainter _furniture;
  final SpanPainter _span;
  final WallPainter _walls;
  final SlipRoadPainter _slipRoads;
  final TunnelPainter _tunnels;

  void drawBox(Canvas c, VisionSeg near, VisionSeg far, Prop p, Vector2 size) {
    switch (p.kind) {
      case PropKind.wall:
        _walls.draw(c, near, far, p, size);
      case PropKind.slipRoad:
        _slipRoads.draw(c, near, far, p, size);
      case PropKind.tunnel:
        _tunnels.draw(c, near, far, p, size);
      default:
        _buildings.draw(c, near, far, p, size);
    }
  }

  void drawBillboard(Canvas c, VisionSeg v, Prop p, Vector2 size) {
    if (p.kind.spansRoad) {
      _span.draw(c, v, p, size);
      return;
    }
    final halfW = p.width * v.k1;
    final x = v.x1 + p.side * v.w1 * p.offset;
    if (x + halfW * 2 < 0 || x - halfW * 2 > size.x) return;

    final y = v.y1;
    final h = p.height * v.k1;
    if (h < 1.5) return;

    c.save();
    c.clipRect(Rect.fromLTRB(0, 0, size.x, v.clip));
    switch (p.kind) {
      case PropKind.broadleaf:
      case PropKind.pine:
      case PropKind.acacia:
      case PropKind.bush:
        _trees.draw(c, v, p, x, y, halfW, h);
      case PropKind.lamp:
      case PropKind.sign:
      case PropKind.billboard:
      case PropKind.exitSign:
        _furniture.draw(c, v, p, x, y, halfW, h);
      default:
        break;
    }
    c.restore();
  }
}
