// Project imports:
import '../../../../common/constants/app_assets.dart';
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../domain/models/scene_id.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../cubit/menu_target.dart';

/// Returns the preview image asset for a scene.
String sceneAsset(SceneId id) => switch (id) {
  SceneId.city => AppAssets.sceneCity,
  SceneId.suburbs => AppAssets.sceneSuburbs,
  SceneId.thikaRoad => AppAssets.sceneThikaRoad,
  SceneId.jungle => AppAssets.sceneJungle,
  SceneId.dirtRoad => AppAssets.sceneDirtRoad,
};

/// The preview picture of a menu entry; the reception has its own.
String menuAsset(MenuTarget target) =>
    target.isReception ? AppAssets.restroom : sceneAsset(target.scene!);

/// Returns the localized label for a menu target.
String menuLabel(AppLocalizations l10n, MenuTarget target) => target.isReception
    ? l10n.receptionTitle
    : l10n.sceneTitle(target.scene!);
