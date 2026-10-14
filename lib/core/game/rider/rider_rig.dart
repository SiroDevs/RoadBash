/// The one place that controls how big the rider is and how high it sits.
/// Heights are in design-box units (the 120 x 170 space the parts are drawn in).
class RiderRig {
  /// Responsive fit: how much of a lane's width and of the screen's height the
  /// rider fills at [scale] 1.
  static const double laneFill = 0.62;
  static const double screenFill = 0.30;

  /// Stock design-space Y of the highest point of the bike (seat handle) and of
  /// the rider (helmet crown).
  static const double stockBikeTop = 28;
  static const double stockRiderTop = -46;

  /// Multiplies everything: bike, rider, wheel and shadow. Grows and shrinks
  /// around the tyre contact point, so the bike never leaves the road.
  double scale = 1;

  /// Raises the bike body above the wheel. The wheel is never touched, and the
  /// rider is carried up with the bike.
  double bikeHeight = 0;

  /// Raises the rider relative to the bike, on top of [bikeHeight].
  double riderHeight = 0;

  double get bikeLift => bikeHeight;
  double get riderLift => bikeHeight + riderHeight;

  /// Where the tops currently are in design space.
  double get bikeTop => stockBikeTop - bikeLift;
  double get riderTop => stockRiderTop - riderLift;
}
