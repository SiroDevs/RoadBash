// Dart imports:
import 'dart:ui';

// Project imports:
import '../../common/universal/prop.dart';
import '../road_projection.dart';
import '../scene_theme.dart';
import 'post_painter.dart';
import 'spectator_painter.dart';

/// Chooses the painter for the finish posts and the cheering crowd.
class FinishPainter {
  FinishPainter(SceneTheme theme)
    : _post = PostPainter(theme),
      _spectator = SpectatorPainter(theme);

  final PostPainter _post;
  final SpectatorPainter _spectator;

  /// Draws a finish-area prop such as a post or spectator.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    switch (prop.kind) {
      case PropKind.post:
        _post.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.spectator:
        _spectator.draw(canvas, vision, prop, anchorX, anchorY, width, height);
      default:
        break;
    }
  }
}
