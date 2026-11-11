// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';

/// A leg put down on the ground: the thigh stays as seated, the shin turns about
/// the knee to a set knee angle and stretches until the boot touches the ground.
class PlantedLeg {
  PlantedLeg(InkedSheet sheet, String side)
    : _shin = sheet.part('leg${side}Shin'),
      _knee = sheet.anchor('leg$side.knee') {
    final hip = sheet.anchor('leg$side.hip');
    final ankle = sheet.anchor('leg$side.ankle');
    final shinLength = (ankle - _knee).distance;
    final seatedAngle = math.atan2(ankle.dy - _knee.dy, ankle.dx - _knee.dx);
    _axis = Offset(math.cos(seatedAngle), math.sin(seatedAngle));
    final raw = _plantedAngle(hip) - seatedAngle;
    _turn = math.atan2(math.sin(raw), math.cos(raw));
    final bootBottom = _bottomOf(sheet.part('boot$side'));
    final drop = groundY - bootBottom;
    final plantedAngle = seatedAngle + _turn;
    final reach = (ankle.dy + drop - _knee.dy) / math.sin(plantedAngle);
    _stretch = reach / shinLength;
    final planted = _knee + Offset.fromDirection(plantedAngle, reach);
    _bootShift = planted - ankle;
  }

  static const double kneeAngle = 140 * math.pi / 180;
  static const double groundY = 158;
  static const double jointRadius = 5.5;

  final InkedPart _shin;
  final Offset _knee;
  late final Offset _axis;
  late final double _turn;
  late final double _stretch;
  late final Offset _bootShift;

  /// How far the boot moves from its seated place at full [amount].
  Offset bootShift(double amount) => _bootShift * amount;

  /// Paints the shin turned and stretched by [amount] from 0 to 1.
  void paintShin(Canvas canvas, double amount) {
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
      _knee.dx - (m00 * _knee.dx + m01 * _knee.dy),
      _knee.dy - (m10 * _knee.dx + m11 * _knee.dy),
      0,
      1,
    ]);
    canvas.drawCircle(_knee, jointRadius, _legFill);
    canvas
      ..save()
      ..transform(matrix);
    _shin.paint(canvas);
    canvas.restore();
  }

  /// Fill of the leg itself, not of its pads.
  Paint get _legFill {
    final index = _shin.part.shapes.indexWhere(
      (shape) => shape.name.endsWith('Leg'),
    );
    return _shin.inks[index < 0 ? 0 : index].fill;
  }

  /// Direction of the shin that gives the knee angle, pointing downward.
  double _plantedAngle(Offset hip) {
    final up = math.atan2(hip.dy - _knee.dy, hip.dx - _knee.dx);
    final first = up + kneeAngle, second = up - kneeAngle;
    return math.sin(first) >= math.sin(second) ? first : second;
  }

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
