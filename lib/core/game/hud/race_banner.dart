// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../../common/constants/app_constants.dart';
import '../race/race_controller.dart';
import '../road/road_renderer.dart';
import '../utils/canvas_text.dart';
import 'hud_colors.dart';
import 'hud_strings.dart';

/// Draws the briefing, countdown, go and finish banners at the top of the screen.
class RaceBanner {
  RaceBanner(this.road, this.race, this.strings, this.briefing);

  final RoadRenderer road;
  final RaceController race;
  final HudStrings strings;

  /// Hint lines shown before the countdown; the first is the level's title.
  final List<String> briefing;

  /// The banner at the end of the race: busted, crashed or finished.
  String _endBanner() => race.busted
      ? strings.busted
      : (race.crashedOut ? strings.crashed : strings.finish);

  /// Draws the countdown, go and finish banner.
  void paint(Canvas canva, Size size) {
    if (race.briefing > 0) {
      _briefing(canva, size);
      return;
    }
    final big = math.min(size.height * 0.16, size.width * 0.2);
    final centre = Offset(size.width / 2, size.height * 0.12);
    final text = race.countdown > 0
        ? '${race.countdown.ceil()}'
        : race.finished
        ? _endBanner()
        : (race.elapsed < 0.9 ? strings.go : null);
    if (text != null) {
      paintText(
        canva,
        text,
        centre,
        big,
        race.busted || race.crashedOut ? HudColors.red : HudColors.gold,
        fontFamily: AppConstants.displayFont,
        weight: FontWeight.w400,
        shadow: true,
      );
    } else if (race.running && road.stopped && !road.throttle) {
      paintText(
        canva,
        strings.holdGas,
        centre,
        math.min(size.height * 0.06, size.width * 0.06),
        HudColors.white,
        shadow: true,
      );
    }
  }

  /// Draws the level title and its hints where the banner normally goes, so
  /// the player reads them just before the countdown.
  void _briefing(Canvas canva, Size size) {
    if (briefing.isEmpty) return;
    final title = math.min(size.height * 0.075, size.width * 0.075);
    final line = math.min(size.height * 0.045, size.width * 0.036);
    final height = title * 1.3 + (briefing.length - 1) * line * 1.45;
    var y =
        math.max(size.height * 0.02, size.height * 0.12 - height / 2) +
        title * 0.65;
    paintText(
      canva,
      briefing.first,
      Offset(size.width / 2, y),
      title,
      HudColors.gold,
      fontFamily: AppConstants.displayFont,
      weight: FontWeight.w400,
      shadow: true,
    );
    y += title * 0.65 + line * 0.85;
    for (final text in briefing.skip(1)) {
      paintText(
        canva,
        text,
        Offset(size.width / 2, y),
        line,
        HudColors.white,
        shadow: true,
      );
      y += line * 1.45;
    }
  }
}
