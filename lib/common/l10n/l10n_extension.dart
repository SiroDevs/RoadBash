// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../domain/models/player_profile.dart';
import '../../domain/models/scene_id.dart';
import '../../l10n/gen/app_localizations.dart';

/// Adds an `l10n` shortcut to [BuildContext].
extension L10nContext on BuildContext {
  /// Returns the localized strings for this context.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Localized scene text.
extension SceneL10n on AppLocalizations {
  /// Returns the localized scene title.
  String sceneTitle(SceneId id) => switch (id) {
    SceneId.city => sceneCity,
    SceneId.suburbs => sceneSuburbs,
    SceneId.thikaRoad => sceneThikaRoad,
    SceneId.jungle => sceneJungle,
    SceneId.dirtRoad => sceneDirtRoad,
  };

  /// Returns the localized scene description.
  String sceneBlurb(SceneId id) => switch (id) {
    SceneId.city => blurbCity,
    SceneId.suburbs => blurbSuburbs,
    SceneId.thikaRoad => blurbThikaRoad,
    SceneId.jungle => blurbJungle,
    SceneId.dirtRoad => blurbDirtRoad,
  };
}

/// Localized player name helpers.
extension ProfileL10n on PlayerProfile {
  /// Returns the player's name, or the default name when it is empty.
  String displayName(AppLocalizations l10n) =>
      name.trim().isEmpty ? l10n.defaultPlayerName : name;
}