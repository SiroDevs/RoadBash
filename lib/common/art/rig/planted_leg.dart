// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../sheet/art_ink.dart';
import 'rider_leg.dart';

/// A leg placed on the ground, with its knee bent to reach the road.
class PlantedLeg {
  PlantedLeg(InkedSheet sheet, String side)
    : _leg = RiderLeg(sheet, 'leg$side'),
      _boot = sheet.part('boot$side') {
    final shinLength = (_leg.ankle - _leg.knee).distance;
    final seatedAngle = math.atan2(
      _leg.ankle.dy - _leg.knee.dy,
      _leg.ankle.dx - _leg.knee.dx,
    );
    final raw = _plantedAngle() - seatedAngle;
    _turn = math.atan2(math.sin(raw), math.cos(raw));
    final bootBottom = _bottomOf(_boot);
    final drop = groundY - bootBottom;
    final plantedAngle = seatedAngle + _turn;
    final reach =
        (_leg.ankle.dy + drop - _leg.knee.dy) / math.sin(plantedAngle);
    _stretch = reach / shinLength;
    final planted = _leg.knee + Offset.fromDirection(plantedAngle, reach);
    _bootShift = planted - _leg.ankle;
  }

  static const double kneeAngle = 150 * math.pi / 180;
  static const double groundY = 120;

  final RiderLeg _leg;
  final InkedPart _boot;
  late final double _turn;
  late final double _stretch;
  late final Offset _bootShift;

  /// How far the boot moves from its seated place at full [amount].
  Offset bootShift(double amount) => _bootShift * amount;

  /// Paints the complete leg as its foot moves down to the ground.
  void paint(Canvas canvas, double amount) {
    _leg.paint(
      canvas,
      kneeAngle: _turn * amount,
      lowerStretch: 1 + (_stretch - 1) * amount,
    );
  }

  /// Direction of the lower leg that gives the knee angle, pointing down.
  double _plantedAngle() {
    final up = math.atan2(
      _leg.hip.dy - _leg.knee.dy,
      _leg.hip.dx - _leg.knee.dx,
    );
    final first = up + kneeAngle, second = up - kneeAngle;
    return math.sin(first) >= math.sin(second) ? first : second;
  }

  /// Lowest point of the boot artwork.
  static double _bottomOf(InkedPart boot) {
    var bottom = -double.infinity;
    for (final shape in boot.part.shapes) {
      for (final point in shape.points) {
        bottom = math.max(bottom, point.dy);
      }
    }
    return bottom;
  }
}
