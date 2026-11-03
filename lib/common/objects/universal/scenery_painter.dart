// Dart imports:
import 'dart:ui';

// Project imports:
import '../../../core/game/road/road_projection.dart';
import '../../../core/game/road/scene_theme.dart';
import '../rock/rock_painter.dart';
import '../tree/acacia_painter.dart';
import '../tree/broadleaf_painter.dart';
import '../tree/bush_painter.dart';
import '../tree/palm_painter.dart';
import '../tree/pine_painter.dart';
import 'contact_shadow.dart';
import 'foliage_palette.dart';
import 'prop.dart';

/// Chooses the painter for each tree, bush, palm or boulder.
class SceneryPainter {
  SceneryPainter(SceneTheme theme) : this._(theme, ContactShadow(theme), FoliagePalette(theme));

  SceneryPainter._(SceneTheme theme, ContactShadow shadow, FoliagePalette palette)
    : _broadleaf = BroadleafPainter(palette, shadow),
      _pine = PinePainter(palette, shadow),
      _bush = BushPainter(palette, shadow),
      _acacia = AcaciaPainter(palette, shadow),
      _palm = PalmPainter(palette, shadow),
      _rock = RockPainter(theme, shadow);

  final BroadleafPainter _broadleaf;
  final PinePainter _pine;
  final BushPainter _bush;
  final AcaciaPainter _acacia;
  final PalmPainter _palm;
  final RockPainter _rock;

  /// Draws the tree or boulder for a prop.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on.
  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width, double height) {
    switch (prop.kind) {
      case PropKind.broadleaf:
        _broadleaf.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.pine:
        _pine.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.bush:
        _bush.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.acacia:
        _acacia.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.palm:
        _palm.draw(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.rock:
        _rock.draw(canvas, vision, anchorX, anchorY, width, height);
      default:
        break;
    }
  }
}
