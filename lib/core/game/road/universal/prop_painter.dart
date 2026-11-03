// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../../domain/models/scene_id.dart';
import '../building/building_painter.dart';
import '../cliff/cliff_painter.dart';
import '../finish/finish_painter.dart';
import '../guardrail/guardrail_painter.dart';
import '../kiosk/kiosk_painter.dart';
import '../mountain/mountain_painter.dart';
import '../scene_theme.dart';
import '../slip_road/slip_road_painter.dart';
import '../tunnel/tunnel_painter.dart';
import '../wall/wall_painter.dart';
import 'prop.dart';
import 'road_projection.dart';
import 'scenery_painter.dart';
import 'span_painter.dart';
import 'street_furniture_painter.dart';

/// Paints every kind of prop using the specialised painters.
class PropPainter {
  PropPainter(SceneTheme theme)
      : _buildings = BuildingPainter(theme),
        _trees = SceneryPainter(theme),
        _finish = FinishPainter(theme),
        _furniture = StreetFurniturePainter(theme),
        _span = SpanPainter(theme),
        _walls = WallPainter(theme),
        _guardrails = GuardrailPainter(theme),
        _slipRoads = SlipRoadPainter(theme),
        _tunnels = TunnelPainter(theme),
        _kiosks = KioskPainter(theme),
        _mountains = MountainPainter(theme),
        _cliffs = theme.id == SceneId.jungle ? CliffPainter(theme) : null;

  final BuildingPainter _buildings;
  final SceneryPainter _trees;
  final FinishPainter _finish;
  final StreetFurniturePainter _furniture;
  final SpanPainter _span;
  final WallPainter _walls;
  final GuardrailPainter _guardrails;
  final SlipRoadPainter _slipRoads;
  final TunnelPainter _tunnels;
  final KioskPainter _kiosks;
  final MountainPainter _mountains;
  final CliffPainter? _cliffs;

  /// Draws the cliff edges beside the road, behind the scenery.
  void drawCliffs(Canvas canvas, List<VisionSeg> visions, int count, Vector2 size) =>
      _cliffs?.draw(canvas, visions, count, size);

  /// Draws box-shaped props such as buildings and walls.
  void drawBox(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    switch (prop.kind) {
      case PropKind.wall:
        _walls.draw(canvas, near, far, prop, size);
      case PropKind.guardrail:
        _guardrails.draw(canvas, near, far, prop, size);
      case PropKind.slipRoad:
        _slipRoads.draw(canvas, near, far, prop, size);
      case PropKind.tunnel:
        _tunnels.draw(canvas, near, far, prop, size);
      case PropKind.kiosk:
        _kiosks.draw(canvas, near, far, prop, size);
      case PropKind.mountain:
        _mountains.draw(canvas, near, far, prop, size);
      default:
        _buildings.draw(canvas, near, far, prop, size);
    }
  }

  /// Draws sprite-like props such as trees, signs and spans.
  void drawBillboard(Canvas canvas, VisionSeg vision, Prop prop, Vector2 size) {
    if (prop.kind.spansRoad) {
      _span.draw(canvas, vision, prop, size);
      return;
    }
    final halfW = prop.width * vision.k1;
    final anchorX = vision.x1 + prop.side * vision.w1 * prop.offset;
    if (anchorX + halfW * 2 < 0 || anchorX - halfW * 2 > size.x) return;

    final anchorY = vision.y1;
    final height = prop.height * vision.k1;
    if (height < 1.5) return;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.x, vision.clip));
    switch (prop.kind) {
      case PropKind.broadleaf:
      case PropKind.pine:
      case PropKind.acacia:
      case PropKind.bush:
      case PropKind.palm:
      case PropKind.rock:
        _trees.draw(canvas, vision, prop, anchorX, anchorY, halfW, height);
      case PropKind.post:
      case PropKind.spectator:
        _finish.draw(canvas, vision, prop, anchorX, anchorY, halfW, height);
      case PropKind.lamp:
      case PropKind.sign:
      case PropKind.billboard:
      case PropKind.exitSign:
        _furniture.draw(canvas, vision, prop, anchorX, anchorY, halfW, height);
      default:
        break;
    }
    canvas.restore();
  }
}
