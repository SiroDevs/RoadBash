// Project imports:
import '../../l10n/gen/app_localizations.dart';

/// Formats a shilling amount with thousands separators and no sign.
String groupThousands(int amount) => amount.abs().toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (match) => ',',
);

/// Formats a wallet amount in the player's language; a debt gets a minus sign.
String formatMoney(AppLocalizations l10n, int amount) => amount < 0
    ? l10n.walletDebt(groupThousands(amount))
    : l10n.walletAmount(groupThousands(amount));
