// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../domain/models/scene_id.dart';

/// An entry of the menu grid: one of the scenes, or the reception.
class MenuTarget extends Equatable {
  const MenuTarget.scene(SceneId this.scene);
  const MenuTarget.reception() : scene = null;

  /// Null for the reception.
  final SceneId? scene;

  bool get isReception => scene == null;

  @override
  List<Object?> get props => [scene];
}
