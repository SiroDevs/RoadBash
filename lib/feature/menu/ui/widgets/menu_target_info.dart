// Project imports:
import '../../../../common/constants/app_assets.dart';
import '../../../../domain/models/scene_id.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../cubit/menu_target.dart';

/// Returns the preview image asset for a scene.
String sceneAsset(SceneId id) => switch (id) {
  SceneId.city => AppAssets.sceneCity,
  SceneId.suburbs => AppAssets.sceneSuburbs,
  SceneId.thikaRoad => AppAssets.sceneThikaRoad,
  SceneId.jungle => AppAssets.sceneJungle,
  SceneId.dirtRoad => AppAssets.sceneDirtRoad,
};

/// The preview picture of a menu entry; the reception and the boardroom use
/// the restroom picture.
String menuAsset(MenuTarget target) =>
    target.isScene ? sceneAsset(target.scene!) : AppAssets.restroom;

/// Returns the localized label for a menu target.
String menuLabel(AppLocalizations l10n, MenuTarget target) =>
    switch (target.place) {
      MenuPlace.scene => l10n.sceneTitle(target.scene!),
      MenuPlace.reception => l10n.receptionTitle.toUpperCase(),
      MenuPlace.boardroom => l10n.boardroomTitle.toUpperCase(),
    };
