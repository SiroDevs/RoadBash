/// Localized texts shown on the dashboard.
class HudStrings {
  const HudStrings({
    required this.go,
    required this.finish,
    required this.holdGas,
    required this.speedUnit,
    required this.rpmUnit,
    required this.lap,
    required this.remaining,
  });

  final String go, finish, holdGas, speedUnit, rpmUnit;
  final String Function(int lap, int laps) lap;
  final String Function(String km) remaining;
}
