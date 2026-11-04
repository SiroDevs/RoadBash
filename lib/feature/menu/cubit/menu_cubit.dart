// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'menu_memory.dart';
import 'menu_target.dart';

/// The highlighted entry of the menu. It starts on the last place the player
/// went to from the menu, or null (the first entry) on a fresh start.
@injectable
class MenuCubit extends Cubit<MenuTarget?> {
  MenuCubit(this._memory) : super(_memory.last);

  final MenuMemory _memory;

  /// Highlights [target] without going anywhere.
  void select(MenuTarget target) => emit(target);

  /// Highlights [target] and remembers it as the last place visited.
  void open(MenuTarget target) {
    _memory.last = target;
    emit(target);
  }

  /// Moves the highlight by [delta] entries of [items], wrapping around.
  void move(int delta, List<MenuTarget> items) {
    final current = math.max(0, items.indexOf(state ?? items.first));
    select(items[(current + delta) % items.length]);
  }

  /// Moves the highlight one row up (-1) or down (1), wrapping around.
  void moveVertical(int direction, List<MenuTarget> items, int columns) {
    final scenes = [
      for (final target in items)
        if (target.isScene) target,
    ];
    final others = [
      for (final target in items)
        if (!target.isScene) target,
    ];
    if (scenes.isEmpty || others.isEmpty) return;
    final current = state ?? items.first;
    if (current.isScene) {
      _moveFromScene(direction, scenes, others, current, columns);
    } else {
      _moveFromOther(direction, scenes, others, current, columns);
    }
  }

  /// Moves within the scene grid, or leaves it for the reception/boardroom.
  void _moveFromScene(
    int direction,
    List<MenuTarget> scenes,
    List<MenuTarget> others,
    MenuTarget current,
    int columns,
  ) {
    final sceneIndex = scenes.indexOf(current);
    final nextIndex = sceneIndex + direction * columns;
    if (nextIndex >= 0 && nextIndex < scenes.length) {
      return select(scenes[nextIndex]);
    }
    final leftSide = (sceneIndex % columns) * 2 < columns;
    select(leftSide ? others.first : others.last);
  }

  /// Moves from the reception/boardroom row back into the scene grid.
  void _moveFromOther(
    int direction,
    List<MenuTarget> scenes,
    List<MenuTarget> others,
    MenuTarget current,
    int columns,
  ) {
    final column = others.indexOf(current) == 0 ? 0 : columns - 1;
    final lastRowStart = ((scenes.length - 1) ~/ columns) * columns;
    final index = direction < 0 ? lastRowStart + column : column;
    select(scenes[math.min(index, scenes.length - 1)]);
  }
}
