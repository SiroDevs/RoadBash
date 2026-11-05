// Project imports:
import '../../../common/utils/money_util.dart';
import '../../../domain/models/career.dart';
import '../../../domain/models/level_rules.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../l10n/l10n_extension.dart';

/// Builds the hints shown just before a race: the level, what it takes to
/// reach the next one, what that unlocks, and what a win pays.
///
/// The first line is the title; the rest are short hint lines.
List<String> levelBriefing(AppLocalizations l10n, Career career) {
  final rules = career.rules;
  final next = rules.next;
  return [
    l10n.levelLabel(rules.level).toUpperCase(),
    if (next == null)
      l10n.hintTopLevel
    else
      l10n.hintNextLevel(
        LevelRules.winsToAdvance,
        next.level,
        career.streak.clamp(0, LevelRules.winsToAdvance).toInt(),
      ),
    if (next != null && next.newScenes.isNotEmpty)
      l10n.hintUnlocks(next.newScenes.map(l10n.sceneTitle).join(', ')),
    if (rules.paysPrize)
      l10n.hintPrize(
        groupThousands(rules.winPrize),
        (LevelRules.bestTimeBonus * 100).round(),
        (LevelRules.cleanRaceBonus * 100).round(),
      )
    else
      l10n.hintNoPrize,
  ];
}
