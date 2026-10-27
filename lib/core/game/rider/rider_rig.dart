class RiderRig {
  static const double laneFill = 0.3;
  static const double screenFill = 0.22;

  static const double stockBikeTop = 28;
  static const double stockRiderTop = -46;

  double scale = 1;

  double bikeHeight = 0;

  double riderHeight = 0;

  double get bikeLift => bikeHeight;
  double get riderLift => bikeHeight + riderHeight;

  double get bikeTop => stockBikeTop - bikeLift;
  double get riderTop => stockRiderTop - riderLift;
}
