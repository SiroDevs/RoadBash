/// Where a rival is drawn relative to the player, eased so overtakes show.
///
/// A rival that is much faster than the player would otherwise cross the
/// whole visible area in a frame or two. The drawn offset follows the true
/// one but moves slowly while it is close to the player and speeds up as it
/// gets farther away, so a rival passing a slow or stopped player is seen
/// arriving, drawing level and pulling ahead. Standings use the true offset.
class ShownOffset {
  static const double _calmSpeed = 1200;
  static const double _calmGain = 2.5;

  double _value = 0;
  bool _ready = false;

  /// Moves toward [target] and returns the new offset.
  double follow(double dt, double target) {
    if (!_ready) {
      _ready = true;
      _value = target;
      return _value;
    }
    final reach = (_calmSpeed + _calmGain * _value.abs()) * dt;
    _value += (target - _value).clamp(-reach, reach).toDouble();
    return _value;
  }
}
