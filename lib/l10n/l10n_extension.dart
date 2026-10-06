// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../domain/models/player_profile.dart';
import '../domain/models/scene_id.dart';
import 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension SceneL10n on AppLocalizations {
  String sceneTitle(SceneId id) =>
      id == SceneId.city ? sceneCity : sceneSuburbs;

  String sceneBlurb(SceneId id) =>
      id == SceneId.city ? blurbCity : blurbSuburbs;
}

extension ProfileL10n on PlayerProfile {
  String displayName(AppLocalizations l10n) =>
      name.trim().isEmpty ? l10n.defaultPlayerName : name;
}
