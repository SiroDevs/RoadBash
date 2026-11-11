// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
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
    _axis = Offset(math.cos(seatedAngle), math.sin(seatedAngle));
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
  static const double jointRadius = 5.5;

  final RiderLeg _leg;
  final InkedPart _boot;
  late final Offset _axis;
  late final double _turn;
  late final double _stretch;
  late final Offset _bootShift;

  /// How far the boot moves from its seated place at full [amount].
  Offset bootShift(double amount) => _bootShift * amount;

  /// Paints the complete leg as its foot moves down to the ground.
  void paint(Canvas canvas, double amount) {
    _leg.paintWithLowerLeg(canvas, (canvas, lowerLeg) {
      if (amount <= 0.01) {
        lowerLeg.paint(canvas);
      } else {
        _paintPlantedLowerLeg(canvas, lowerLeg, amount);
      }
    });
  }

  /// Turns and stretches the lower leg as its foot reaches the road.
  void _paintPlantedLowerLeg(Canvas canvas, InkedPart lowerLeg, double amount) {
    final stretch = (_stretch - 1) * amount;
    final turn = _turn * amount;
    final xx = 1 + stretch * _axis.dx * _axis.dx;
    final xy = stretch * _axis.dx * _axis.dy;
    final yy = 1 + stretch * _axis.dy * _axis.dy;
    final cos = math.cos(turn), sin = math.sin(turn);
    final m00 = cos * xx - sin * xy, m01 = cos * xy - sin * yy;
    final m10 = sin * xx + cos * xy, m11 = sin * xy + cos * yy;
    final matrix = Float64List.fromList([
      m00,
      m10,
      0,
      0,
      m01,
      m11,
      0,
      0,
      0,
      0,
      1,
      0,
      _leg.knee.dx - (m00 * _leg.knee.dx + m01 * _leg.knee.dy),
      _leg.knee.dy - (m10 * _leg.knee.dx + m11 * _leg.knee.dy),
      0,
      1,
    ]);
    _leg.paintKnee(canvas, jointRadius);
    canvas
      ..save()
      ..transform(matrix);
    lowerLeg.paint(canvas);
    canvas.restore();
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
