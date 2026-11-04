/// Localized texts shown on the dashboard.
class HudStrings {
  const HudStrings({
    required this.go,
    required this.finish,
    required this.holdGas,
    required this.gas,
    required this.speedUnit,
    required this.rpmUnit,
    required this.lap,
    required this.remaining,
    required this.police,
    required this.pullOver,
    required this.busted,
  });

  final String go, finish, holdGas, gas, speedUnit, rpmUnit;
  final String police, pullOver, busted;
  final String Function(int lap, int laps) lap;
  final String Function(String km) remaining;
}
