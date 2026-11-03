// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../../common/vehicle/civilian_kind.dart';
import '../../common/vehicle/matatu_painter.dart';
import '../../common/vehicle/sedan_painter.dart';
import '../../common/vehicle/truck_painter.dart';
import '../../common/vehicle/vehicle_canvas.dart';
import 'road_actor.dart';

export '../../common/vehicle/civilian_kind.dart';

/// A civilian car, matatu or truck driving the same way as the race.
///
/// It keeps to one lane at a steady speed. The traffic flow decides where it
/// appears and when it is recycled further up the road.
class CivilianCar implements RoadActor {
  CivilianCar(this.index);

  /// Distance used to hide a car that is not on the road.
  static const double parked = -1e9;

  /// A lane is this many rider heights wide on screen.
  static const double _laneInHeights = 1.75;

  static final SedanPainter _sedan = SedanPainter();
  static final MatatuPainter _matatu = MatatuPainter();
  static final TruckPainter _truck = TruckPainter();

  final int index;

  CivilianKind kind = CivilianKind.sedan;
  Color color = const Color(0xFF8E9EBC);
  Color accent = const Color(0xFFFFFFFF);

  /// Speed in road units per second.
  double speed = 0;

  /// Lane the car drives in.
  int lane = 0;

  /// Half the car's width in road-lateral units.
  double halfWidth = 0.15;

  /// True while the car is on the road; false when it is parked out of sight.
  bool active = false;

  /// Lateral position the car eases toward.
  double target = 0;

  double _distance = parked;
  double _lateral = 0;

  @override
  double get distance => _distance;

  @override
  double get lateral => _lateral;

  /// Puts the car on the road.
  void place({
    required CivilianKind kind,
    required Color color,
    required Color accent,
    required double distance,
    required int lane,
    required double lateral,
    required double speed,
    required double laneWidth,
  }) {
    this.kind = kind;
    this.color = color;
    this.accent = accent;
    this.lane = lane;
    this.speed = speed;
    halfWidth = laneWidth * kind.width / _laneInHeights / 2;
    _distance = distance;
    _lateral = lateral;
    target = lateral;
    active = true;
  }

  /// Takes the car off the road.
  void park() {
    active = false;
    _distance = parked;
  }

  /// Drives the car forward and eases it toward its lane position.
  void drive(double dt) {
    if (!active || dt <= 0) return;
    _distance += speed * dt;
    _lateral += (target - _lateral) * math.min(1.0, dt * 3);
  }

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    final v = VehicleCanvas(canvas, ground, height * kind.width, height * kind.tall)..shadow();
    switch (kind) {
      case CivilianKind.sedan:
        _sedan.paint(v, color, accent);
      case CivilianKind.matatu:
        _matatu.paint(v, color, accent);
      case CivilianKind.truck:
        _truck.paint(v, color, accent);
    }
  }
}
