// Dart imports:
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import 'planted_leg.dart';

/// Legs and boots of the seated rider; one leg can be put down on the ground.
class SeatedLegs {
  SeatedLegs(this._sheet)
    : _planted = {for (final side in _sides) side: PlantedLeg(_sheet, side)};

  static const List<String> _sides = ['L', 'R'];

  final InkedSheet _sheet;
  final Map<String, PlantedLeg> _planted;

  /// Paints both legs; the leg on [plantedSide] is put down by [amount].
  void paintLegs(Canvas canvas, String plantedSide, double amount) {
    for (final side in _sides) {
      _sheet.part('leg${side}Thigh').paint(canvas);
      if (side == plantedSide && amount > 0.01) {
        _planted[side]!.paintShin(canvas, amount);
      } else {
        _sheet.part('leg${side}Shin').paint(canvas);
      }
    }
  }

  /// Paints both boots; the one on [plantedSide] follows its leg to the ground.
  void paintBoots(Canvas canvas, String plantedSide, double amount) {
    for (final side in _sides) {
      final lowered = side == plantedSide
          ? _planted[side]!.bootShift(amount)
          : Offset.zero;
      canvas
        ..save()
        ..translate(lowered.dx, lowered.dy);
      _sheet.part('boot$side').paint(canvas);
      canvas.restore();
    }
  }
}
