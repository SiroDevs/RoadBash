// Project imports:
import '../../../core/game/hud/hud_strings.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Builds the HUD's texts in the player's language.
HudStrings hudStringsFor(AppLocalizations l10n) => HudStrings(
  go: l10n.hudGo,
  finish: l10n.hudFinish,
  holdGas: l10n.hudHoldGas,
  gas: l10n.hudGasLabel,
  speedUnit: l10n.hudSpeedUnit,
  rpmUnit: l10n.hudRpmUnit,
  lap: l10n.hudLap,
  remaining: l10n.hudRemaining,
  police: l10n.hudPolice,
  pullOver: l10n.hudPullOver,
  busted: l10n.hudBusted,
  crashed: l10n.hudCrashed,
);
