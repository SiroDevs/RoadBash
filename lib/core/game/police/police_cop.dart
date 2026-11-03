// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Project imports:
import '../race/rival_pose_driver.dart';
import '../rider/look/rider_looks.dart';
import '../rider/rider_painter.dart';
import '../rider/rider_sprite.dart';
import '../road/traffic/road_actor.dart';
import '../road/universal/config/vehicle_config.dart';

/// A police rider with flashing lights, drawn like a rival.
class PoliceCop implements RoadActor {
  PoliceCop() : sprite = RiderSprite(look: RiderLooks.cop);

  /// Distance used to hide the cop while it is off the road.
  static const double parked = -1e9;

  static const double _accel = VehicleConfig.maxSpeed / 2.6;
  static const double _brake = VehicleConfig.maxSpeed * 1.5;
  static const double _gain = 2.5;
  static const double _maxVelocity = 0.9;
  static const double _shoveDecay = 4;

  static const Color _red = Color(0xFFFF2D2D);
  static const Color _blue = Color(0xFF2D7BFF);

  final RiderSprite sprite;
  late final RivalPoseDriver _poseDriver = RivalPoseDriver(sprite.pose, 77);
  final Paint _ink = Paint()..isAntiAlias = true;

  /// True while the cop is on the road.
  bool active = false;

  /// Speed in road units per second.
  double speed = 0;

  /// Seconds the cop has been on the road; drives the light flash.
  double clock = 0;

  double _distance = parked;
  double _lateral = 0;
  double _shove = 0;

  @override
  double get distance => _distance;

  @override
  double get lateral => _lateral;

  /// Puts the cop on the road.
  void launch({
    required double distance,
    required double lateral,
    required double speed,
  }) {
    _distance = distance;
    _lateral = lateral;
    this.speed = speed;
    _shove = 0;
    clock = 0;
    active = true;
  }

  /// Takes the cop off the road.
  void park() {
    active = false;
    _distance = parked;
    speed = 0;
  }

  /// Pushes the cop sideways, as when the player brushes against it.
  void shoveBy(double amount) => _shove += amount;

  /// Rides the cop for one frame toward a speed and a lateral line.
  void advance(
    double dt, {
    required double targetSpeed,
    required double targetLateral,
    required double maxLateral,
    required double curve,
  }) {
    if (!active || dt <= 0) return;
    clock += dt;
    final change = (targetSpeed - speed)
        .clamp(-_brake * dt, _accel * dt)
        .toDouble();
    speed = math.max(0.0, speed + change);
    _distance += speed * dt;

    final wanted = ((targetLateral - _lateral) * _gain)
        .clamp(-_maxVelocity, _maxVelocity)
        .toDouble();
    _shove *= math.exp(-_shoveDecay * dt);
    final previous = _lateral;
    _lateral = (_lateral + (wanted + _shove) * dt)
        .clamp(-maxLateral, maxLateral)
        .toDouble();
    _poseDriver.update(
      dt: dt,
      speed: speed,
      steerRate: (_lateral - previous) / dt,
      curve: curve,
      atStart: false,
      crossed: false,
    );
  }

  @override
  void paint(Canvas canvas, Offset ground, double height) {
    final scale = height / RiderSprite.height;
    sprite.paintAt(canvas, ground, scale);
    _lights(canvas, ground, scale);
  }

  // Paints the two flashing roof lights above the rider's head.
  void _lights(Canvas canvas, Offset ground, double scale) {
    final top = ground.dy - RiderPartPainter.groundY * scale;
    final redLeft = (clock * 5).floor().isEven;
    final left = Offset(ground.dx - 9 * scale, top + 2 * scale);
    final right = Offset(ground.dx + 9 * scale, top + 2 * scale);
    _light(canvas, left, 5 * scale, redLeft ? _red : _blue);
    _light(canvas, right, 5 * scale, redLeft ? _blue : _red);
  }

  void _light(Canvas canvas, Offset at, double radius, Color color) {
    _ink.color = color.withAlpha(70);
    canvas.drawCircle(at, radius * 2.6, _ink);
    _ink.color = color;
    canvas.drawCircle(at, radius, _ink);
    _ink.color = const Color(0xCCFFFFFF);
    canvas.drawCircle(at, radius * 0.4, _ink);
  }
}
