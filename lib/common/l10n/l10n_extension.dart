// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../domain/models/player_profile.dart';
import '../../domain/models/scene_id.dart';
import '../../l10n/gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension SceneL10n on AppLocalizations {
  String sceneTitle(SceneId id) => switch (id) {
    SceneId.city => sceneCity,
    SceneId.suburbs => sceneSuburbs,
    SceneId.thikaRoad => sceneThikaRoad,
    SceneId.jungle => sceneJungle,
    SceneId.dirtRoad => sceneDirtRoad,
  };

  String sceneBlurb(SceneId id) => switch (id) {
    SceneId.city => blurbCity,
    SceneId.suburbs => blurbSuburbs,
    SceneId.thikaRoad => blurbThikaRoad,
    SceneId.jungle => blurbJungle,
    SceneId.dirtRoad => blurbDirtRoad,
  };
}

extension ProfileL10n on PlayerProfile {
  String displayName(AppLocalizations l10n) =>
      name.trim().isEmpty ? l10n.defaultPlayerName : name;
}