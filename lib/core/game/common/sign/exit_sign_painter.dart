// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../road/road_projection.dart';
import '../../road/scene_theme.dart';
import '../../utils/paint_utils.dart';
import '../universal/prop.dart';
import '../universal/signage/sign_text.dart';

/// Paints a motorway exit sign: a wide board on two posts.
class ExitSignPainter {
  ExitSignPainter(SceneTheme theme)
    : _pole = fogRamp(theme.poleColor, theme.fog),
      _green = fogRamp(theme.signGreen, theme.fog),
      _blue = fogRamp(const Color(0xFF1B44AE), theme.fog),
      _white = fogRamp(const Color(0xFFF2F2EC), theme.fog);

  final List<Paint> _pole, _green, _blue, _white;

  /// Draws an exit sign.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on. [prop] holds the sign panels.
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width,
      double height, Prop prop) {
    final blue = prop.tint;
    final panel = prop.signs.isEmpty ? null : prop.signs.first;
    final aspect = panel?.aspect;
    final poleW = math.max(1.0, width * 0.05);
    final postX = width * (aspect == null ? 0.6 : 0.8);
    final paint = fogged(_pole, vision.fog);
    canvas.drawRect(
        Rect.fromLTRB(anchorX - postX - poleW, anchorY - height, anchorX - postX + poleW, anchorY + 1),
        paint);
    canvas.drawRect(
        Rect.fromLTRB(anchorX + postX - poleW, anchorY - height, anchorX + postX + poleW, anchorY + 1),
        paint);
    final boardH = aspect == null ? height * 0.5 : (width * 2) / aspect;
    final board = Rect.fromLTRB(anchorX - width, anchorY - height, anchorX + width, anchorY - height + boardH);
    if (panel != null && panel.framed) {
      canvas.drawRect(board.inflate(math.max(0.8, boardH * 0.03)),
          fogged(_white, vision.fog));
    }
    canvas.drawRect(board, fogged(blue == 1 ? _blue : _green, vision.fog));
    if (vision.fog < 0.6 && panel != null && board.height > 12) {
      // Sign text
      SignText.drawPanel(canvas, board, panel);
    } else if (vision.fog < 0.6) {
      // Sign text bars
      for (var n = 0; n < 3; n++) {
        final ty = board.top + board.height * (0.2 + n * 0.26);
        canvas.drawRect(
            Rect.fromLTRB(board.left + width * 0.25, ty, board.right - width * 0.25,
                ty + board.height * 0.1),
            fogged(_white, vision.fog));
      }
    }
  }
}
