// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../race/race_controller.dart';
import '../race/race_result.dart';
import '../road/road_config.dart';
import '../road/road_renderer.dart';
import '../utils/canvas_text.dart';
import '../utils/paint_utils.dart';
import 'dash_face.dart';
import 'dash_layout.dart';
import 'hud_strings.dart';

/// Bike dashboard over the bottom of the screen: speedo, rev counter, race
/// position, progress bar, clock, names and the gap to the nearest rival
/// (green when you lead, red when you trail).
class DashboardHud extends PositionComponent {
  DashboardHud(this.road, this.race, this.strings) : super(priority: 10);

  final RoadRenderer road;
  final RaceController race;
  final HudStrings strings;

  DashLayout? _l;
  Picture? _face;

  static const _white = Color(0xFFFFFFFF);
  static const _green = Color(0xFF35D06B);
  static const _red = Color(0xFFE5483A);
  static const _gold = Color(0xFFFFC857);

  final Paint _needle = fillPaint(const Color(0xFFC0301F))
    ..strokeCap = StrokeCap.round;
  final Paint _hub = fillPaint(const Color(0xFF1A1A1F));
  final Paint _barBg = fillPaint(const Color(0xFF050507));
  final Paint _zoneRed = fillPaint(const Color(0xFFE5322D));
  final Paint _zoneAmber = fillPaint(const Color(0xFFE9B93A));
  final Paint _zoneGreen = fillPaint(const Color(0xFF3DBB5A));

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    final l = DashLayout(size);
    _l = l;
    _face?.dispose();
    _face = DashFace.build(l, strings);
  }

  @override
  void render(Canvas canvas) {
    final l = _l;
    final face = _face;
    if (l == null || face == null) return;
    canvas.drawPicture(face);
    _needleAt(canvas, l.speedC, l.speedR, road.speedKmh / RoadConfig.topSpeedKmh);
    _needleAt(canvas, l.rpmC, l.rpmR, road.rpm);
    _progress(canvas, l);
    _readouts(canvas, l);
    _banner(canvas);
  }

  void _needleAt(Canvas c, Offset ctr, double r, double fraction) {
    _needle.strokeWidth = math.max(2.0, r * 0.045);
    c.drawLine(ctr,
        DashLayout.polar(ctr, DashLayout.dialAngle(fraction), r * 0.8), _needle);
    c.drawCircle(ctr, r * 0.09, _hub);
  }

  void _progress(Canvas c, DashLayout l) {
    final w = l.pw * 0.2;
    final bar = Rect.fromLTWH(
        l.left + l.pw * 0.5 - w / 2, l.top + l.ph * 0.17, w, l.ph * 0.05);
    c.drawRect(bar, _barBg);
    c.save();
    c.clipRect(Rect.fromLTWH(bar.left, bar.top, bar.width * race.progress, bar.height));
    for (final (from, to, paint) in [
      (0.0, 0.15, _zoneRed),
      (0.15, 0.5, _zoneAmber),
      (0.5, 1.0, _zoneGreen),
    ]) {
      c.drawRect(
          Rect.fromLTRB(bar.left + bar.width * from, bar.top,
              bar.left + bar.width * to, bar.bottom),
          paint);
    }
    c.restore();
  }

  void _readouts(Canvas c, DashLayout l) {
    Offset at(double fx, double fy) =>
        Offset(l.left + l.pw * fx, l.top + l.ph * fy);
    final small = l.ph * 0.13;

    paintText(c, '${race.position}', l.centre.center, l.ph * 0.2, _white,
        fontFamily: AppConstants.displayFont, weight: FontWeight.w400);
    paintText(c, formatTime(race.elapsed, short: true), at(0.5, 0.93),
        l.ph * 0.14, _white);
    paintText(c, race.playerName, at(0.13, 0.90), small, _white);

    final rival = race.nearest;
    if (rival == null || !race.running) return;
    paintText(c, rival.name, at(0.87, 0.90), small, _white);
    final ahead = race.playerAhead;
    paintText(
      c,
      '${ahead ? '▼' : '▲'} ${race.gapSeconds.toStringAsFixed(3)}',
      at(0.62, 0.12),
      l.ph * 0.14,
      ahead ? _green : _red,
    );
  }

  void _banner(Canvas c) {
    final big = size.y * 0.16;
    final centre = Offset(size.x / 2, size.y * 0.28);
    final text = race.countdown > 0
        ? '${race.countdown.ceil()}'
        : race.finished
            ? strings.finish
            : (race.elapsed < 0.9 ? strings.go : null);
    if (text != null) {
      paintText(c, text, centre, big, _gold,
          fontFamily: AppConstants.displayFont,
          weight: FontWeight.w400,
          shadow: true);
    } else if (race.running && road.stopped && !road.throttle) {
      paintText(c, strings.holdGas, centre, size.y * 0.06, _white, shadow: true);
    }
    paintText(c, strings.lap(race.lap, race.laps),
        Offset(size.x / 2, size.y * 0.035), size.y * 0.04, _white,
        shadow: true);
  }
}
