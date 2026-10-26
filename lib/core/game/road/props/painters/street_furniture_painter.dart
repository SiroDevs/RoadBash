// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';

class StreetFurniturePainter {
  StreetFurniturePainter(SceneTheme theme)
      : _pole = fogRamp(theme.poleColor, theme.fog),
        _signFace = fogRamp(const Color(0xFFE8E4D8), theme.fog),
        _signInk = fogRamp(const Color(0xFF2E3238), theme.fog),
        _green = fogRamp(theme.signGreen, theme.fog),
        _blue = fogRamp(const Color(0xFF1F5FA8), theme.fog),
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

  final List<Paint> _pole, _signFace, _signInk, _green, _blue, _white;
  final List<List<Paint>> _boards;

  void draw(Canvas c, VisionSeg v, Prop p, double x, double y, double w,
      double h) {
    switch (p.kind) {
      case PropKind.lamp:
        _lamp(c, v, x, y, w, h, p.side, p.detail);
      case PropKind.sign:
        _sign(c, v, x, y, w, h);
      case PropKind.billboard:
        _billboard(c, v, x, y, w, h, p.tint);
      case PropKind.exitSign:
        _exitSign(c, v, x, y, w, h, p.tint);
      default:
        break;
    }
  }

  void _lamp(Canvas c, VisionSeg v, double x, double y, double w, double h,
      int side, double arm) {
    final poleW = math.max(1.0, w * 0.35);
    final paint = fogged(_pole, v.fog);
    c.drawRect(Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), paint);
    // Arm over the road
    final reach = -side * w * (5 + arm * 7);
    c.drawRect(
        Rect.fromLTRB(math.min(x, x + reach), y - h,
            math.max(x, x + reach), y - h + poleW * 2.2),
        paint);
    c.drawRect(
        Rect.fromLTRB(x + reach - poleW * 1.6, y - h + poleW * 2.2,
            x + reach + poleW * 1.6, y - h + poleW * 4.4),
        fogged(_signFace, v.fog));
  }

  void _sign(Canvas c, VisionSeg v, double x, double y, double w, double h) {
    final poleW = math.max(1.0, w * 0.17);
    c.drawRect(
        Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), fogged(_pole, v.fog));
    final plate = Rect.fromLTRB(x - w, y - h, x + w, y - h + w * 2.1);
    c.drawRect(plate, fogged(_signFace, v.fog));
    c.drawRect(plate.deflate(math.max(0.6, w * 0.16)), fogged(_signInk, v.fog));
  }

  void _billboard(Canvas c, VisionSeg v, double x, double y, double w,
      double h, int face) {
    final poleW = math.max(1.0, w * 0.07);
    final paint = fogged(_pole, v.fog);
    c.drawRect(Rect.fromLTRB(x - poleW, y - h, x + poleW, y + 1), paint);
    final board = Rect.fromLTRB(x - w, y - h, x + w, y - h + h * 0.34);
    c.drawRect(board.inflate(math.max(0.6, w * 0.03)), paint);
    c.drawRect(board, fogged(_boards[face % _boards.length], v.fog));
    if (v.fog < 0.6) {
      // Board text
      c.drawRect(
          Rect.fromLTRB(board.left + w * 0.2, board.top + board.height * 0.3,
              board.right - w * 0.2, board.top + board.height * 0.42),
          fogged(_white, v.fog));
    }
  }

  void _exitSign(Canvas c, VisionSeg v, double x, double y, double w,
      double h, int blue) {
    final poleW = math.max(1.0, w * 0.05);
    final paint = fogged(_pole, v.fog);
    c.drawRect(
        Rect.fromLTRB(x - w * 0.6 - poleW, y - h, x - w * 0.6 + poleW, y + 1),
        paint);
    c.drawRect(
        Rect.fromLTRB(x + w * 0.6 - poleW, y - h, x + w * 0.6 + poleW, y + 1),
        paint);
    final board = Rect.fromLTRB(x - w, y - h, x + w, y - h + h * 0.5);
    c.drawRect(board, fogged(blue == 1 ? _blue : _green, v.fog));
    if (v.fog < 0.6) {
      // Sign text
      for (var n = 0; n < 3; n++) {
        final ty = board.top + board.height * (0.2 + n * 0.26);
        c.drawRect(
            Rect.fromLTRB(board.left + w * 0.25, ty, board.right - w * 0.25,
                ty + board.height * 0.1),
            fogged(_white, v.fog));
      }
    }
  }
}
