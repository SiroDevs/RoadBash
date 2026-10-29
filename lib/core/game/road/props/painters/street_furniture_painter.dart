// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../utils/paint_utils.dart';
import '../../road_projection.dart';
import '../../scene_theme.dart';
import '../prop.dart';
import 'sign_text.dart';

class StreetFurniturePainter {
  StreetFurniturePainter(SceneTheme theme)
      : _pole = fogRamp(theme.poleColor, theme.fog),
        _signFace = fogRamp(const Color(0xFFE8E4D8), theme.fog),
        _signInk = fogRamp(const Color(0xFF2E3238), theme.fog),
        _green = fogRamp(theme.signGreen, theme.fog),
        _blue = fogRamp(const Color(0xFF1B44AE), theme.fog),
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

  void draw(Canvas canvas, VisionSeg vision, Prop prop, double anchorX, double anchorY, double width,
      double height) {
    switch (prop.kind) {
      case PropKind.lamp:
        _lamp(canvas, vision, anchorX, anchorY, width, height, prop.side, prop.detail);
      case PropKind.sign:
        _sign(canvas, vision, anchorX, anchorY, width, height);
      case PropKind.billboard:
        _billboard(canvas, vision, anchorX, anchorY, width, height, prop);
      case PropKind.exitSign:
        _exitSign(canvas, vision, anchorX, anchorY, width, height, prop);
      default:
        break;
    }
  }

  void _lamp(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height,
      int side, double arm) {
    final poleW = math.max(1.0, width * 0.35);
    final paint = fogged(_pole, vision.fog);
    canvas.drawRect(Rect.fromLTRB(anchorX - poleW, anchorY - height, anchorX + poleW, anchorY + 1), paint);
    // Arm over the road
    final reach = -side * width * (5 + arm * 7);
    canvas.drawRect(
        Rect.fromLTRB(math.min(anchorX, anchorX + reach), anchorY - height,
            math.max(anchorX, anchorX + reach), anchorY - height + poleW * 2.2),
        paint);
    canvas.drawRect(
        Rect.fromLTRB(anchorX + reach - poleW * 1.6, anchorY - height + poleW * 2.2,
            anchorX + reach + poleW * 1.6, anchorY - height + poleW * 4.4),
        fogged(_signFace, vision.fog));
  }

  void _sign(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width, double height) {
    final poleW = math.max(1.0, width * 0.17);
    canvas.drawRect(
        Rect.fromLTRB(anchorX - poleW, anchorY - height, anchorX + poleW, anchorY + 1), fogged(_pole, vision.fog));
    final plate = Rect.fromLTRB(anchorX - width, anchorY - height, anchorX + width, anchorY - height + width * 2.1);
    canvas.drawRect(plate, fogged(_signFace, vision.fog));
    canvas.drawRect(plate.deflate(math.max(0.6, width * 0.16)), fogged(_signInk, vision.fog));
  }

  void _billboard(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width,
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

  void _exitSign(Canvas canvas, VisionSeg vision, double anchorX, double anchorY, double width,
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
