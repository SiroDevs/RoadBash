// Dart imports:
import 'dart:ui';

// Project imports:
import '../sheet/art_ink.dart';
import '../sheet/part_motion.dart';
import 'planted_leg.dart';

/// Legs and boots of the seated rider; one leg can be put down on the ground.
class SeatedLegs {
  SeatedLegs(this._sheet)
    : _planted = {for (final side in _sides) side: PlantedLeg(_sheet, side)};

  static const List<String> _sides = ['L', 'R'];
  static const double _plantedBootAngle = 0.5;
  static const double _plantedBootLeftNudge = 9;

  final InkedSheet _sheet;
  final Map<String, PlantedLeg> _planted;

  /// Paints both legs; the leg on [plantedSide] is put down by [amount].
  void paintLegs(Canvas canvas, String plantedSide, double amount) {
    for (final side in _sides) {
      final plantedAmount = side == plantedSide ? amount : 0.0;
      _planted[side]!.paint(canvas, plantedAmount);
    }
  }

  /// Paints both boots; the one on [plantedSide] follows its leg to the ground.
  void paintBoots(
    Canvas canvas,
    String plantedSide,
    double amount, {
    required bool mirrored,
  }) {
    for (final side in _sides) {
      final planted = side == plantedSide;
      final lowered = planted ? _planted[side]!.bootShift(amount) : Offset.zero;
      final facesBike = planted && amount >= 0.98;
      final angle = facesBike
          ? (mirrored ? -_plantedBootAngle : _plantedBootAngle)
          : 0.0;
      final bootLeftNudge = facesBike
          ? (mirrored ? _plantedBootLeftNudge : -_plantedBootLeftNudge)
          : 0.0;
      canvas
        ..save()
        ..translate(lowered.dx + bootLeftNudge, lowered.dy);
      PartMotion.around(
        canvas,
        _sheet.anchor('boot$side.heel'),
        () => _sheet.part('boot$side').paint(canvas),
        angle: angle,
      );
      canvas.restore();
    }
  }
}
