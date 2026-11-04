// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../domain/models/scene_id.dart';

/// The kinds of place a menu entry leads to.
enum MenuPlace { scene, reception, boardroom }

/// An entry of the menu: one of the scenes, the reception or the boardroom.
class MenuTarget extends Equatable {
  const MenuTarget.scene(SceneId this.scene) : place = MenuPlace.scene;
  const MenuTarget.reception() : scene = null, place = MenuPlace.reception;
  const MenuTarget.boardroom() : scene = null, place = MenuPlace.boardroom;

  final MenuPlace place;
  final SceneId? scene;

  /// True when the target is one of the scenes.
  bool get isScene => place == MenuPlace.scene;

  /// True when the target is the reception.
  bool get isReception => place == MenuPlace.reception;

  /// True when the target is the boardroom.
  bool get isBoardroom => place == MenuPlace.boardroom;

  @override
  List<Object?> get props => [place, scene];
}
