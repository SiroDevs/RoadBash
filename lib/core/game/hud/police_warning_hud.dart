// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../constants/app_constants.dart';
import '../police/police_chase.dart';
import '../race/race_controller.dart';
import '../utils/canvas_text.dart';
import '../utils/paint_utils.dart';
import 'hud_strings.dart';

/// Draws the flashing police warning and the arrest meter.
class PoliceWarningHud {
  static const _white = Color(0xFFFFFFFF);
  static const _red = Color(0xFFE5483A);
  static const _blue = Color(0xFF3D8BFF);

  final Paint _barBg = fillPaint(const Color(0xFF050507));
  final Paint _zoneRed = fillPaint(const Color(0xFFE5322D));
  final Paint _flashRed = fillPaint(const Color(0x40E5322D));
  final Paint _flashBlue = fillPaint(const Color(0x402979FF));

  /// Paints the warning over a screen of [size] while a cop is chasing.
  void paint(Canvas canva, Vector2 size, PoliceChase police, RaceController race, HudStrings strings) {
    if (!police.chasing || race.finished) return;
    final flashRed = (police.cop.clock * 5).floor().isEven;
    final edge = size.x * 0.05;
    canva.drawRect(
      Rect.fromLTWH(0, 0, edge, size.y),
      flashRed ? _flashRed : _flashBlue,
    );
    canva.drawRect(
      Rect.fromLTWH(size.x - edge, 0, edge, size.y),
      flashRed ? _flashBlue : _flashRed,
    );
    paintText(
      canva,
      strings.police,
      Offset(size.x / 2, size.y * 0.26),
      math.min(size.y * 0.07, size.x * 0.07),
      flashRed ? _red : _blue,
      fontFamily: AppConstants.displayFont,
      weight: FontWeight.w400,
      shadow: true,
    );
    if (police.bust <= 0.02) return;
    final bar = Rect.fromCenter(
      center: Offset(size.x / 2, size.y * 0.33),
      width: size.x * 0.3,
      height: size.y * 0.025,
    );
    canva.drawRect(bar, _barBg);
    canva.drawRect(
      Rect.fromLTWH(bar.left, bar.top, bar.width * police.bust, bar.height),
      _zoneRed,
    );
    paintText(
      canva,
      strings.pullOver,
      Offset(size.x / 2, size.y * 0.37),
      math.min(size.y * 0.045, size.x * 0.045),
      _white,
      shadow: true,
    );
  }
}
