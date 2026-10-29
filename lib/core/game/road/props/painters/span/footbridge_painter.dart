// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../../utils/paint_utils.dart';
import '../../../road_projection.dart';
import '../../../scene_theme.dart';
import '../../prop.dart';

class FootbridgePainter {
  FootbridgePainter(SceneTheme theme)
    : _frame = [for (final c in _colors) fogRamp(c, theme.fog)],
      _dark = [for (final c in _colors) fogRamp(shade(c, -0.35), theme.fog)],
      _mesh = [
        for (final c in _colors)
          fogRamp(c.withValues(alpha: 0.42), theme.fog, antiAlias: true),
      ];

  static const List<Color> _colors = [
    Color(0xFF3E6FA3),
    Color(0xFF3F7F57),
    Color(0xFFD8B42A),
    Color(0xFF9C9E99),
  ];

  static const int _arch = 2;

  final List<List<Paint>> _frame, _dark, _mesh;
  final Path _path = Path();

  void draw(
    Canvas canvas,
    VisionSeg vision,
    Prop prop,
    double left,
    double right, {
    double? pillarX,
  }) {
    final style = prop.tint % _frame.length;
    final scale = vision.k1, groundY = vision.y1, fog = vision.fog;
    final top = groundY - prop.height * scale;
    final deck = top + 170 * scale;
    final pw = math.max(1.0, 120 * scale);
    final stair = 1500 * scale;

    // Stairs
    _path.reset();
    _path
      ..moveTo(left, deck)
      ..lineTo(left - stair, groundY)
      ..lineTo(left, groundY)
      ..close()
      ..moveTo(right, deck)
      ..lineTo(right + stair, groundY)
      ..lineTo(right, groundY)
      ..close();
    canvas.drawPath(_path, fogged(_dark[style], fog));

    // Centre pier, standing in the median
    if (pillarX != null) {
      final pier = math.max(1.5, 170 * scale);
      canvas.drawRect(
        Rect.fromLTRB(pillarX - pier, deck, pillarX + pier, groundY + 1),
        fogged(_dark[style], fog),
      );
      canvas.drawRect(
        Rect.fromLTRB(
          pillarX - pier * 2.2,
          deck,
          pillarX + pier * 2.2,
          deck + 110 * scale,
        ),
        fogged(_dark[style], fog),
      );
    }

    // Deck
    canvas.drawRect(Rect.fromLTRB(left - pw, deck, left + pw, groundY + 1), fogged(_dark[style], fog));
    canvas.drawRect(Rect.fromLTRB(right - pw, deck, right + pw, groundY + 1), fogged(_dark[style], fog));
    canvas.drawRect(
      Rect.fromLTRB(left - pw * 1.6, top, right + pw * 1.6, deck),
      fogged(_frame[style], fog),
    );

    // Railing
    final railTop = top - 250 * scale;
    final bar = math.max(1.0, 36 * scale);
    canvas.drawRect(
      Rect.fromLTRB(left - pw * 1.6, railTop, right + pw * 1.6, railTop + bar),
      fogged(_frame[style], fog),
    );
    final posts = ((right - left) / math.max(6.0, 300 * scale)).floor().clamp(2, 28);
    _path.reset();
    for (var n = 0; n <= posts; n++) {
      final postX = left + (right - left) * n / posts;
      _path.addRect(Rect.fromLTRB(postX - bar * 0.5, railTop, postX + bar * 0.5, top));
    }
    canvas.drawPath(_path, fogged(_frame[style], fog));

    if (style == _arch) {
      _archSpan(canvas, fog, style, left, right, railTop, scale);
    } else {
      // Covered walkway
      final roof = railTop - 330 * scale;
      canvas.drawRect(
        Rect.fromLTRB(left - pw * 1.6, roof, right + pw * 1.6, railTop),
        fogged(_mesh[style], fog),
      );
      canvas.drawRect(
        Rect.fromLTRB(left - pw * 2, roof - bar * 1.4, right + pw * 2, roof),
        fogged(_dark[style], fog),
      );
    }
  }

  void _archSpan(
    Canvas canvas,
    double fog,
    int style,
    double left,
    double right,
    double base,
    double scale,
  ) {
    final rise = 1150 * scale;
    final thickness = math.max(1.2, 70 * scale);
    final mid = (left + right) / 2;
    _path.reset();
    const steps = 10;
    for (var n = 0; n <= steps; n++) {
      final fraction = n / steps;
      final postX = left + (right - left) * fraction;
      final yy = base - rise * 4 * fraction * (1 - fraction);
      n == 0 ? _path.moveTo(postX, yy) : _path.lineTo(postX, yy);
    }
    for (var n = steps; n >= 0; n--) {
      final fraction = n / steps;
      final postX = left + (right - left) * fraction;
      _path.lineTo(postX, base - rise * 4 * fraction * (1 - fraction) + thickness);
    }
    _path.close();
    canvas.drawPath(_path, fogged(_frame[style], fog));
    canvas.drawRect(
      Rect.fromLTRB(mid - thickness * 0.5, base - rise, mid + thickness * 0.5, base),
      fogged(_frame[style], fog),
    );
  }
}
