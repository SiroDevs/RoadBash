/// App-wide constants such as the title and fonts.
class AppConstants {
  AppConstants._();

  static const appTitle = "RoadBash";
  static const appCredits = "© Siro Devs";
  static const appPackageName = "com.sirodevs.roadbash";
  static const kFontFamily = 'Rajdhani';
  static const displayFont = 'Anton';
  static const anonymousName = 'AnonPlayer';

  /// Master switch for steering by tilting the device. The tilt code stays in
  /// the project; set this to true to bring it back.
  static const tiltSteeringEnabled = false;
}