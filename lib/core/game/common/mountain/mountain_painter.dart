// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../road/road_projection.dart';
import '../../road/scene_theme.dart';
import '../../utils/paint_utils.dart';
import '../../utils/pseudo_random.dart';
import '../universal/box_frame.dart';
import '../universal/prop.dart';

/// Paints the walls beside the jungle road: forested mountain sides, and the
/// bare limestone and umber walls of the pass, which can lean over the road.
class MountainPainter {
  MountainPainter(SceneTheme theme)
    : _forest = fogRamp(shade(theme.treeDark, -0.15), theme.fog),
      _forestMid = fogRamp(theme.treeDark, theme.fog),
      _leaf = fogRamp(theme.treeLight, theme.fog),
      _limestone = fogRamp(const Color(0xFFB4B0A6), theme.fog),
      _limestoneShade = fogRamp(const Color(0xFF8C887F), theme.fog),
      _umber = fogRamp(const Color(0xFF7B6347), theme.fog),
      _umberShade = fogRamp(const Color(0xFF574531), theme.fog),
      _moss = fogRamp(const Color(0xFF55703A), theme.fog),
      _base = fogRamp(const Color(0xFF2B3A2A), theme.fog);

  static const double _detailFog = 0.55;
  static const int _streaks = 6;
  static const int _clumpCount = 9;

  final List<Paint> _forest, _forestMid, _leaf, _limestone, _limestoneShade;
  final List<Paint> _umber, _umberShade, _moss, _base;
  final Path _path = Path();

  /// Draws a stretch of wall between two segments. [Prop.tint] 0 to 2 is a
  /// forested mountain side, 3 pale limestone and 4 umber rock; for rock walls
  /// [Prop.detail] is how far the top leans over the road.
  void draw(Canvas canvas, VisionSeg near, VisionSeg far, Prop prop, Vector2 size) {
    final box = BoxFrame(near, far, prop, size);
    if (!box.visible) return;
    final rock = prop.tint >= 3;
    final lean = rock ? prop.detail * 0.4 : 0.0;
    final inward = -prop.side.toDouble();
    final fog = far.fog;
    final seed = prop.anchor * 17 + prop.tint;

    Offset at(double t, double f) {
      final width = near.w1 + (far.w1 - near.w1) * t;
      final base = box.base1 + (box.base2 - box.base1) * t;
      final top = box.top1 + (box.top2 - box.top1) * t;
      final x = box.xi1 + (box.xi2 - box.xi1) * t + inward * lean * width * f;
      return Offset(x, base + (top - base) * f);
    }

    void patch(List<Paint> ramp, double t0, double t1, double f0, double f1) {
      final a = at(t0, f0), b = at(t1, f0), c = at(t1, f1), d = at(t0, f1);
      drawQuad(canvas, _path, fogged(ramp, fog), a.dx, a.dy, b.dx, b.dy, c.dx, c.dy, d.dx, d.dy);
    }

    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, 0, size.x, near.clip));
    final body = switch (prop.tint) {
      3 => _limestone,
      4 => _umber,
      _ => _forest,
    };
    patch(body, 0, 1, 0, 1);
    if (fog < _detailFog) {
      if (rock) {
        _rockFace(canvas, patch, at, near, far, seed, prop.tint == 3);
      } else {
        _forestFace(canvas, patch, at, near, far, seed);
      }
    }
    patch(_base, 0, 1, 0, 0.07);
    _crown(canvas, at, near, far, seed, fog);
    canvas.restore();
  }

  /// Streaks, ledges with moss and a band of trees at the foot of a rock wall.
  void _rockFace(
    Canvas canvas,
    void Function(List<Paint>, double, double, double, double) patch,
    Offset Function(double, double) at,
    VisionSeg near,
    VisionSeg far,
    int seed,
    bool pale,
  ) {
    final shadeRamp = pale ? _limestoneShade : _umberShade;
    for (var streak = 0; streak < _streaks; streak++) {
      final start = pseudoRandom(seed + streak * 3) * 0.9;
      final span = 0.02 + 0.06 * pseudoRandom(seed + streak * 3 + 1);
      final from = 0.08 + 0.3 * pseudoRandom(seed + streak * 3 + 2);
      patch(streak.isEven ? shadeRamp : (pale ? _limestone : _umber), start, start + span, from, 1);
    }
    for (var ledge = 0; ledge < 4; ledge++) {
      final start = pseudoRandom(seed + 40 + ledge * 3) * 0.7;
      final height = 0.2 + 0.6 * pseudoRandom(seed + 41 + ledge * 3);
      patch(_moss, start, start + 0.12 + 0.12 * pseudoRandom(seed + 42 + ledge), height, height + 0.04);
    }
    patch(_forestMid, 0, 1, 0.07, 0.16);
    _clumps(canvas, at, near, far, seed + 90, 0.07, 0.2, 5);
  }

  /// Dense bush clumps over a forested slope, with a patch of bare rock.
  void _forestFace(
    Canvas canvas,
    void Function(List<Paint>, double, double, double, double) patch,
    Offset Function(double, double) at,
    VisionSeg near,
    VisionSeg far,
    int seed,
  ) {
    final start = pseudoRandom(seed + 5) * 0.5;
    patch(_umber, start, start + 0.25, 0.55 + 0.2 * pseudoRandom(seed + 6), 0.9);
    _clumps(canvas, at, near, far, seed, 0.05, 0.95, _clumpCount);
  }

  /// Scatters round clumps of foliage between two height fractions.
  void _clumps(
    Canvas canvas,
    Offset Function(double, double) at,
    VisionSeg near,
    VisionSeg far,
    int seed,
    double low,
    double high,
    int count,
  ) {
    for (var clump = 0; clump < count; clump++) {
      final t = pseudoRandom(seed + clump * 4);
      final f = low + (high - low) * pseudoRandom(seed + clump * 4 + 1);
      final width = near.w1 + (far.w1 - near.w1) * t;
      final radius = width * (0.16 + 0.16 * pseudoRandom(seed + clump * 4 + 2));
      final centre = at(t, f);
      final ramp = clump.isEven ? _leaf : _forestMid;
      canvas.drawOval(
        Rect.fromCenter(center: centre, width: radius * 2.2, height: radius * 1.5),
        fogged(ramp, far.fog),
      );
    }
  }

  /// Draws pine tops along the crest so the wall has a living skyline.
  void _crown(Canvas canvas, Offset Function(double, double) at, VisionSeg near, VisionSeg far, int seed, double fog) {
    for (var tree = 0; tree < 6; tree++) {
      final t = (tree + pseudoRandom(seed + tree)) / 6;
      final top = at(t, 1);
      final scale = near.k1 + (far.k1 - near.k1) * t;
      final height = (520 + 380 * pseudoRandom(seed + tree + 9)) * scale;
      _path
        ..reset()
        ..moveTo(top.dx - height * 0.22, top.dy + height * 0.1)
        ..lineTo(top.dx + height * 0.22, top.dy + height * 0.1)
        ..lineTo(top.dx, top.dy - height)
        ..close();
      canvas.drawPath(_path, fogged(_forestMid, fog));
    }
  }
}
