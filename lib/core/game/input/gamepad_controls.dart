/// Normalized controls reported by one gamepad.
class GamepadControls {
  const GamepadControls({
    this.steer = 0,
    this.throttle = false,
    this.brake = false,
    this.boost = false,
    this.attack = false,
  });

  static const neutral = GamepadControls();

  final double steer;
  final bool throttle, brake, boost, attack;
}
