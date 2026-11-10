// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../look/rider_look.dart';
import 'art_ink.dart';
import 'art_shape.dart';
import 'bike_tones.dart';
import 'data/bike_data.dart';
import 'part_motion.dart';

/// One bike shape that is either fixed or morphs between two outlines.
class _BikeRow {
  _BikeRow._(this.mode, this.group, this.name, this.from, this.to);

  /// Reads a 'mode|group|name|from|to' morph row.
  factory _BikeRow.morph(String text) {
    final fields = text.split('|');
    final first = parsePoints(fields[3]);
    final second = parsePoints(fields[4]);
    return _BikeRow._(
      fields[0],
      fields[1],
      fields[2],
      first.isEmpty ? second : first,
      second.isEmpty ? first : second,
    );
  }

  /// Reads a 'group|name|points' row that never morphs.
  factory _BikeRow.fixed(String text) {
    final fields = text.split('|');
    final points = parsePoints(fields[2]);
    return _BikeRow._('F', fields[0], fields[1], points, points);
  }

  final String mode;
  final String group;
  final String name;
  final List<Offset> from;
  final List<Offset> to;

  bool get isPair => mode == 'P';
}

/// The motorcycle drawn from its parts, turning smoothly with the rider's yaw.
class BikeFigure {
  BikeFigure(RiderLook look)
    : _straight = [for (final row in bikeStraightRows) _BikeRow.fixed(row)],
      _left = [for (final row in bikeLeftTurnRows) _BikeRow.morph(row)],
      _right = [for (final row in bikeRightTurnRows) _BikeRow.morph(row)] {
    final colors = LookColors(look, forBike: true);
    _inks = {
      for (final row in [..._straight, ..._left, ..._right])
        row.name: ShapeInk(colors.of(bikeToneOf(row.name))),
    };
  }

  static const double maxYaw = 0.7;
  static const Offset steerPivot = Offset(60, 55);

  final List<_BikeRow> _straight;
  final List<_BikeRow> _left;
  final List<_BikeRow> _right;
  late final Map<String, ShapeInk> _inks;
  final Path _scratch = Path();

  /// Paints the bike turned by [yaw] (negative left, positive right).
  void paint(Canvas canvas, double yaw, {double steer = 0}) {
    final turn = (yaw.abs() / maxYaw).clamp(0.0, 1.0).toDouble();
    final rows = turn < 0.01 ? _straight : (yaw < 0 ? _left : _right);
    for (final row in rows) {
      final fade = switch (row.mode) {
        'A' => 1 - turn,
        'B' => turn,
        _ => 1.0,
      };
      if (fade < 0.04) continue;
      if (row.group == 'bars') {
        PartMotion.around(
          canvas,
          steerPivot,
          () => _paintRow(canvas, row, turn, fade),
          angle: steer * 0.11,
        );
      } else {
        _paintRow(canvas, row, turn, fade);
      }
    }
  }

  void _paintRow(Canvas canvas, _BikeRow row, double turn, double fade) {
    _scratch.reset();
    final first = row.from;
    final second = row.to;
    final amount = row.isPair ? turn : 0.0;
    for (var index = 0; index < first.length; index++) {
      final point = Offset.lerp(first[index], second[index], amount)!;
      if (index == 0) {
        _scratch.moveTo(point.dx, point.dy);
      } else {
        _scratch.lineTo(point.dx, point.dy);
      }
    }
    _scratch.close();
    final ink = _inks[row.name]!;
    if (fade >= 0.99) {
      canvas.drawPath(_scratch, ink.fill);
      canvas.drawPath(_scratch, ink.edge);
      return;
    }
    final faded = Paint()
      ..isAntiAlias = true
      ..color = ink.fill.color.withValues(alpha: math.min(1.0, fade));
    canvas.drawPath(_scratch, faded);
  }
}
