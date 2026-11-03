// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../domain/models/scene_id.dart';
import '../../utils/paint_utils.dart';
import '../scene_theme.dart';
import 'ground/terrain.dart';
import 'road_projection.dart';

/// Shared drawing for marks that lie on the road surface.
class GroundMarks {
  final Path _path = Path();

  /// The colour of bare earth in a scene: the verge on the jungle road, the
  /// road itself on the dirt road.
  static Color soilTone(SceneTheme theme) =>
      theme.id == SceneId.jungle ? theme.shoulder : theme.roadLight;

  /// True when something at [lateral] would lie on the firm vehicle line.
  static bool onLane(Ground ground, double lateral, double radius) =>
      ground.hasLane && (lateral - ground.laneCenter).abs() < ground.laneHalf + radius;

  /// Fills a band between two lateral offsets.
  void band(Canvas canvas, VisionSeg vision, double fog, List<Paint> ramp, double from, double to) {
    _path.reset();
    add(vision, from, to);
    canvas.drawPath(_path, fogged(ramp, fog));
  }

  /// Starts a path made of several bands.
  void begin() => _path.reset();

  /// Adds a band between two lateral offsets to the current path.
  void add(VisionSeg vision, double offset, double outer) {
    addQuad(
      _path,
      vision.x1 + vision.w1 * offset,
      vision.y1,
      vision.x1 + vision.w1 * outer,
      vision.y1,
      vision.x2 + vision.w2 * outer,
      vision.y2,
      vision.x2 + vision.w2 * offset,
      vision.y2,
    );
  }

  /// Fills the current path.
  void fill(Canvas canvas, List<Paint> ramp, double fog) =>
      canvas.drawPath(_path, fogged(ramp, fog));

  /// Draws an oval of [radius] road widths on a segment at [along] (0 to 1).
  void spot(
    Canvas canvas,
    VisionSeg vision,
    List<Paint> ramp,
    double fog,
    double lateral,
    double along,
    double radius,
    double rise,
  ) {
    final width = vision.w1 + (vision.w2 - vision.w1) * along;
    final x = vision.x1 + (vision.x2 - vision.x1) * along + width * lateral;
    final y = vision.y1 + (vision.y2 - vision.y1) * along;
    final halfWidth = width * radius;
    if (halfWidth < 0.8) return;
    final halfHeight = math.max(0.6, (vision.y1 - vision.y2) * rise);
    canvas.drawOval(
      Rect.fromLTRB(x - halfWidth, y - halfHeight, x + halfWidth, y + halfHeight),
      fogged(ramp, fog),
    );
  }
}
