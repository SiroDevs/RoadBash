/// Tuning knobs for the handlebar. Change a value here and rebuild.
class HandlebarConfig {
  HandlebarConfig._();

  static const double scale = 1.2;
  static const double gripLengthScale = 1.5;

  /// How much thicker the pipe and each grip are drawn, in artwork units
  /// (the artwork is 300 units wide). Zero gives the original thickness.
  static const double pipeThicken = 6.0;
  static const double gripThicken = 7.0;

  /// Lifts the whole handlebar, as a share of the dashboard's height.
  static const double raise = 0.06;
}
