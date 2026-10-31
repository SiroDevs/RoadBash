// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../constants/app_constants.dart';
import '../race/race_controller.dart';
import '../race/race_result.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../utils/canvas_text.dart';
import '../utils/paint_utils.dart';
import 'dashboard_face.dart';
import 'dashboard_layout.dart';
import 'hud_strings.dart';

/// Dashboard overlay showing speed, rpm and race banners.
class DashboardHud extends PositionComponent {
  DashboardHud(this.road, this.race, this.strings) : super(priority: 10);

  final RoadRenderer road;
  final RaceController race;
  final HudStrings strings;

  DashboardLayout? _layout;
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
    final layout = DashboardLayout(size);
    _layout = layout;
    _face?.dispose();
    _face = DashboardFace.build(layout, strings);
  }

  @override
  void render(Canvas canvas) {
    final layout = _layout;
    final face = _face;
    if (layout == null || face == null) return;
    canvas.drawPicture(face);
    _needleAt(
      canvas,
      layout.speedOffset,
      layout.speedRadius,
      road.speedKmh / VehicleConfig.topSpeedKmh,
    );
    _needleAt(canvas, layout.rpmOffset, layout.rpmRadius, road.rpm);
    _progress(canvas, layout);
    _readouts(canvas, layout);
    _banner(canvas);
  }

  /// Draws a gauge needle at a fraction of the dial.
  void _needleAt(Canvas canva, Offset ctr, double radius, double fraction) {
    _needle.strokeWidth = math.max(2.0, radius * 0.045);
    canva.drawLine(
      ctr,
      DashboardLayout.polar(ctr, DashboardLayout.dialAngle(fraction), radius * 0.8),
      _needle,
    );
    canva.drawCircle(ctr, radius * 0.09, _hub);
  }

  // Progress indicator
  void _progress(Canvas canva, DashboardLayout layout) {
    final width = layout.pw * 0.25;
    final bar = Rect.fromLTWH(
      layout.left + layout.pw * 0.5 - width / 2,
      layout.top + layout.ph * 0.12,
      width,
      layout.ph * 0.05,
    );
    canva.drawRect(bar, _barBg);
    canva.save();
    canva.clipRect(
      Rect.fromLTWH(bar.left, bar.top, bar.width * race.progress, bar.height),
    );
    for (final (from, to, paint) in [
      (0.0, 0.15, _zoneRed),
      (0.15, 0.5, _zoneAmber),
      (0.5, 1.0, _zoneGreen),
    ]) {
      canva.drawRect(
        Rect.fromLTRB(
          bar.left + bar.width * from,
          bar.top,
          bar.left + bar.width * to,
          bar.bottom,
        ),
        paint,
      );
    }
    canva.restore();
  }

  // Dashboard texts
  void _readouts(Canvas canva, DashboardLayout layout) {
    Offset at(double fx, double fy) =>
        Offset(layout.left + layout.pw * fx, layout.top + layout.ph * fy);
    final small = math.max(
      9.0,
      math.min(layout.ph * 0.13, layout.pw * 0.035),
    );

    // Race position
    paintText(
      canva,
      '${race.position}',
      layout.centre.center,
      layout.ph * 0.16,
      _white,
      fontFamily: AppConstants.displayFont,
    );

    // Elapsed time
    paintText(
      canva,
      formatTime(race.elapsed, short: true),
      at(0.5, 0.62),
      layout.ph * 0.14,
      _white,
    );

    // Laps, or the kilometres left when the scene is one long road
    paintText(
      canva,
      race.countsLaps
          ? strings.lap(race.lap, race.laps)
          : strings.remaining(race.remainingKm(road.fullDistance).toStringAsFixed(1)),
      at(0.13, 0.4),
      layout.ph * 0.1,
      _white,
    );

    // Current player name
    paintText(canva, race.playerName, at(0.13, 0.60), small, _white);

    // Rival player name
    final rival = race.nearest;
    if (rival == null || !race.running) return;
    paintText(canva, rival.name, at(0.87, 0.60), small, _white);
    final ahead = race.playerAhead;
    paintText(
      canva,
      '${ahead ? '▼' : '▲'} ${race.gapSeconds.toStringAsFixed(2)}',
      at(0.87, 0.4),
      layout.ph * 0.1,
      ahead ? _green : _red,
    );
  }

  /// Draws the countdown, go and finish banner.
  void _banner(Canvas canva) {
    final big = math.min(size.y * 0.16, size.x * 0.2);
    final centre = Offset(size.x / 2, size.y * 0.12);
    final text = race.countdown > 0
        ? '${race.countdown.ceil()}'
        : race.finished
        ? strings.finish
        : (race.elapsed < 0.9 ? strings.go : null);
    if (text != null) {
      paintText(
        canva,
        text,
        centre,
        big,
        _gold,
        fontFamily: AppConstants.displayFont,
        weight: FontWeight.w400,
        shadow: true,
      );
    } else if (race.running && road.stopped && !road.throttle) {
      paintText(
        canva,
        strings.holdGas,
        centre,
        math.min(size.y * 0.06, size.x * 0.06),
        _white,
        shadow: true,
      );
    }
  }
}
