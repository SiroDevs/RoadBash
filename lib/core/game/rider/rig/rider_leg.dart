// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../art/sheet/art_ink.dart';
import '../art/sheet/part_motion.dart';

/// One complete leg polygon with knee movement applied as a smooth bend.
class RiderLeg {
  RiderLeg(InkedSheet sheet, String id)
    : _part = sheet.part(id),
      hip = sheet.anchor('$id.hip'),
      knee = sheet.anchor('$id.knee'),
      ankle = sheet.anchor('$id.ankle') {
    _lowerAxis = _unit(ankle - knee);
    _bendNormal = _unit(_unit(knee - hip) + _lowerAxis);
  }

  static const double _kneeBlend = 8;

  final InkedPart _part;
  final Offset hip;
  final Offset knee;
  final Offset ankle;
  late final Offset _lowerAxis;
  late final Offset _bendNormal;

  /// Paints the complete leg with hip rotation and a continuous knee bend.
  void paint(
    Canvas canvas, {
    double hipAngle = 0,
    double kneeAngle = 0,
    double lowerStretch = 1,
  }) {
    PartMotion.around(canvas, hip, () {
      if (kneeAngle.abs() < 0.0001 && (lowerStretch - 1).abs() < 0.0001) {
        _part.paint(canvas);
      } else {
        _part.paintMapped(
          canvas,
          (point) => _bendPoint(point, kneeAngle, lowerStretch),
        );
      }
    }, angle: hipAngle);
  }

  /// Maps each vertex through a smooth bend while preserving one closed path.
  Offset _bendPoint(Offset point, double angle, double stretch) {
    final fromKnee = point - knee;
    final alongLeg =
        fromKnee.dx * _bendNormal.dx + fromKnee.dy * _bendNormal.dy;
    final progress = (alongLeg / _kneeBlend).clamp(0.0, 1.0).toDouble();
    final influence = progress * progress * (3 - 2 * progress);
    if (influence <= 0) return point;

    final projection =
        fromKnee.dx * _lowerAxis.dx + fromKnee.dy * _lowerAxis.dy;
    final extension = (stretch - 1) * projection;
    final scaledX = fromKnee.dx + _lowerAxis.dx * extension;
    final scaledY = fromKnee.dy + _lowerAxis.dy * extension;
    final cos = math.cos(angle), sin = math.sin(angle);
    final target =
        knee +
        Offset(scaledX * cos - scaledY * sin, scaledX * sin + scaledY * cos);
    return point + (target - point) * influence;
  }

  /// Normalizes a direction, returning a stable default for a zero vector.
  static Offset _unit(Offset vector) {
    final length = vector.distance;
    if (length < 0.0001) return const Offset(0, 1);
    return Offset(vector.dx / length, vector.dy / length);
  }
}
