// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../utils/paint_utils.dart';
import '../scene_theme.dart';
import '../universal/prop.dart';
import '../universal/road_projection.dart';
import '../universal/signage/sign_text.dart';

/// Paints a billboard: a tall post carrying a coloured board with text.
class BillboardPainter {
  BillboardPainter(SceneTheme theme)
    : _pole = fogRamp(theme.poleColor, theme.fog),
      _white = fogRamp(const Color(0xFFF2F2EC), theme.fog),
      _boards = [
        for (final c in _boardColors) fogRamp(c, theme.fog),
      ];

  static const List<Color> _boardColors = [
    Color(0xFF2E6BC6),
    Color(0xFFD23B32),
    Color(0xFFEDE7D6),
    Color(0xFF2A2D33),
    Color(0xFF3FA05B),
  ];

  final List<Paint> _pole, _white;
  final List<List<Paint>> _boards;

  /// Draws a billboard.
  ///
  /// [anchorX] and [anchorY] are the prop's ground point on screen and [width]
  /// and [height] its size in pixels. [vision] is the projected segment it
  /// stands on. [prop] picks the billboard face.
  void draw(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width,
      double height, Prop prop) {
    final face = prop.tint;
    final poleW = math.max(1.0, width * 0.07);
    final paint = fogged(_pole, vision.fog);
    canvas.drawRect(Rect.fromLTRB(anchorX - poleW, anchorY - height, anchorX + poleW, anchorY + 1), paint);
    final board = Rect.fromLTRB(anchorX - width, anchorY - height, anchorX + width, anchorY - height + height * 0.34);
    canvas.drawRect(board.inflate(math.max(0.6, width * 0.03)), paint);
    canvas.drawRect(board, fogged(_boards[face % _boards.length], vision.fog));
    final lines = prop.signs.isEmpty ? const <String>[] : prop.signs.first.texts;
    if (vision.fog < 0.6 && lines.isNotEmpty && board.height > 12) {
      // Board text
      SignText.draw(canvas, board.deflate(width * 0.1), lines,
          color: face % _boards.length == 2 ? const Color(0xFF23262B) : SignText.white);
    } else if (vision.fog < 0.6) {
      // Board text bars
      canvas.drawRect(
          Rect.fromLTRB(board.left + width * 0.2, board.top + board.height * 0.3,
              board.right - width * 0.2, board.top + board.height * 0.42),
          fogged(_white, vision.fog));
    }
  }
}
