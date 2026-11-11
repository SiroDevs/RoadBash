// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';
import '../art/sheet/rider_sheets.dart';
import '../look/rider_look.dart';

/// The rider standing and facing the camera, built from separate parts.
class FrontRiderFigure {
  FrontRiderFigure(RiderLook look)
    : _sheet = InkedSheet.rider(RiderSheets.front, look);

  final InkedSheet _sheet;

  /// Paints the front view in the original layer order.
  void paint(Canvas canvas, {double breath = 0}) {
    for (final id in const ['helmet', 'bootR', 'bootL']) {
      _sheet.part(id).paint(canvas);
    }
    PartMotion.around(
      canvas,
      _sheet.anchor('torso.waist'),
      () => _sheet.part('torso').paint(canvas),
      scaleY: 1 + breath * 0.006,
    );
    for (final side in const ['R', 'L']) {
      PartMotion.around(
        canvas,
        _sheet.anchor('arm$side.shoulder'),
        () => _sheet.part('arm$side').paint(canvas),
        angle: breath * 0.02 * (side == 'R' ? 1 : -1),
      );
    }
    for (final id in const ['legLThigh', 'legLShin', 'legRThigh', 'legRShin']) {
      _sheet.part(id).paint(canvas);
    }
  }
}
