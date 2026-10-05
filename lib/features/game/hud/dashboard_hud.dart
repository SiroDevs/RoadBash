// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../common/widgets/game/canvas_text.dart';
import '../../../common/widgets/game/dash_layout.dart';
import '../../../common/widgets/game/road_config.dart';
import '../../../common/widgets/game/road_renderer.dart';
import '../race_controller.dart';
import '../race_result.dart';
import 'dash_face.dart';

/// Bike dashboard drawn over the bottom of the screen: speedo, rev counter,
/// race position, progress bar, clock, rider names and the gap to the
/// nearest rival (green = you lead, red = you trail).
class DashboardHud extends PositionComponent {
  DashboardHud(this.road, this.race) : super(priority: 10);

  final RoadRenderer road;
  final RaceController race;

  DashLayout? _l;
  Picture? _face;

  static const _white = Color(0xFFFFFFFF);
  static const _green = Color(0xFF35D06B);
  static const _red = Color(0xFFE5483A);

  final Paint _needle = Paint()
    ..color = const Color(0xFFC0301F)
    ..strokeCap = StrokeCap.round;
  final Paint _hub = Paint()..color = const Color(0xFF1A1A1F);
  final Paint _barBg = Paint()..color = const Color(0xFF050507);
  final Paint _zoneRed = Paint()..color = const Color(0xFFE5322D);
  final Paint _zoneAmber = Paint()..color = const Color(0xFFE9B93A);
  final Paint _zoneGreen = Paint()..color = const Color(0xFF3DBB5A);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    final l = DashLayout(size);
    _l = l;
    _face?.dispose();
    _face = DashFace.build(l);
  }

  @override
  void render(Canvas canvas) {
    final l = _l;
    final face = _face;
    if (l == null || face == null) return;
    canvas.drawPicture(face);
    _drawNeedle(canvas, l.speedC, l.speedR, road.speedKmh / RoadConfig.topSpeedKmh);
    _drawNeedle(canvas, l.rpmC, l.rpmR, road.rpm);
    _drawProgress(canvas, l);
    _drawReadouts(canvas, l);
    _drawBanner(canvas);
  }

  void _drawNeedle(Canvas c, Offset ctr, double r, double frac) {
    final f = math.min(1.0, math.max(0.0, frac));
    final a = DashLayout.dialStart + DashLayout.dialSweep * f;
    _needle.strokeWidth = math.max(2.0, r * 0.045);
    c.drawLine(
        ctr, Offset(ctr.dx + math.cos(a) * r * 0.8, ctr.dy + math.sin(a) * r * 0.8), _needle);
    c.drawCircle(ctr, r * 0.09, _hub);
  }

  void _drawProgress(Canvas c, DashLayout l) {
    final w = l.pw * 0.2;
    final bar = Rect.fromLTWH(l.left + l.pw * 0.5 - w / 2, l.top + l.ph * 0.17, w, l.ph * 0.05);
    c.drawRect(bar, _barBg);
    c.save();
    c.clipRect(Rect.fromLTWH(bar.left, bar.top, bar.width * race.progress, bar.height));
    c.drawRect(Rect.fromLTWH(bar.left, bar.top, bar.width * 0.15, bar.height), _zoneRed);
    c.drawRect(Rect.fromLTWH(bar.left + bar.width * 0.15, bar.top, bar.width * 0.35, bar.height), _zoneAmber);
    c.drawRect(Rect.fromLTWH(bar.left + bar.width * 0.5, bar.top, bar.width * 0.5, bar.height), _zoneGreen);
    c.restore();
  }

  void _drawReadouts(Canvas c, DashLayout l) {
    Offset at(double fx, double fy) => Offset(l.left + l.pw * fx, l.top + l.ph * fy);
    final small = l.ph * 0.11;

    paintText(c, '${race.position}', l.centre.center, l.ph * 0.2, _white,
        weight: FontWeight.w800);
    paintText(c, formatTime(race.elapsed, short: true), at(0.5, 0.93), l.ph * 0.12, _white);
    paintText(c, race.playerName, at(0.13, 0.90), small, _white);

    final rival = race.nearest;
    if (rival == null || !race.running) return;
    paintText(c, rival.name, at(0.87, 0.90), small, _white);
    final ahead = race.playerAhead;
    paintText(
      c,
      '${ahead ? '▼' : '▲'} ${race.gapSeconds.toStringAsFixed(3)}',
      at(0.62, 0.12),
      l.ph * 0.12,
      ahead ? _green : _red,
    );
  }

  void _drawBanner(Canvas c) {
    String? text;
    if (race.countdown > 0) {
      text = '${race.countdown.ceil()}';
    } else if (race.finished) {
      text = 'FINISH!';
    } else if (race.elapsed < 0.9) {
      text = 'GO!';
    }
    if (text != null) {
      paintText(c, text, Offset(size.x / 2, size.y * 0.28), size.y * 0.16,
          const Color(0xFFFFC857), weight: FontWeight.w900, shadow: true);
    }
    paintText(c, 'LAP ${race.lap}/${race.laps}', Offset(size.x / 2, size.y * 0.035),
        size.y * 0.03, _white, shadow: true);
  }
}
