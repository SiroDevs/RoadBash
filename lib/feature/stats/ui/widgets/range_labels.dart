// Project imports:
import '../../../../domain/models/stats_models.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Returns the localized label for a stats range.
String rangeLabel(AppLocalizations l10n, StatsRange range) => switch (range) {
  StatsRange.today => l10n.statsRangeToday,
  StatsRange.week => l10n.statsRange7,
  StatsRange.month => l10n.statsRange28,
  StatsRange.quarter => l10n.statsRange90,
  StatsRange.year => l10n.statsRange365,
};
