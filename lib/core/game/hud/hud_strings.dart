/// Text drawn on the canvas by the game; built from the localizations.
class HudStrings {
  const HudStrings({
    required this.go,
    required this.finish,
    required this.holdGas,
    required this.speedUnit,
    required this.rpmUnit,
    required this.lap,
  });

  final String go, finish, holdGas, speedUnit, rpmUnit;
  final String Function(int lap, int laps) lap;
}
