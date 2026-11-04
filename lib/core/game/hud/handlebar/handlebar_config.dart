/// Tuning knobs for the handlebar. Change a value here and rebuild.
class HandlebarConfig {
  HandlebarConfig._();

  /// Multiplies the handlebar's size, which is otherwise worked out from the
  /// screen: 1.0 is the default, 0.8 is smaller, 1.2 is bigger.
  ///
  /// The grips never go past the screen edges, so on a narrow phone held
  /// upright a value above 1.0 may have little or no effect.
  static const double scale = 1.0;

  /// How much thicker the pipe and each grip are drawn, in artwork units
  /// (the artwork is 300 units wide). Zero gives the original thickness.
  static const double pipeThicken = 6.0;
  static const double gripThicken = 7.0;

  /// Lifts the whole handlebar, as a share of the dashboard's height.
  static const double raise = 0.06;
}