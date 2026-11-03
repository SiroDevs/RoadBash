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

  /// Moves the highlight one row up ([dir] < 0) or down ([dir] > 0).
  ///
  /// The scenes sit in a grid of [cols] columns, followed by one row holding
  /// the reception and the boardroom. Leaving the grid lands on the entry
  /// nearest in column, and the movement wraps around.
  void moveVertical(int dir, List<MenuTarget> items, int cols) {
    final scenes = [for (final t in items) if (t.isScene) t];
    final others = [for (final t in items) if (!t.isScene) t];
    if (scenes.isEmpty || others.isEmpty) return;
    final current = state ?? items.first;

    if (!current.isScene) {
      final col = others.indexOf(current) == 0 ? 0 : cols - 1;
      final lastRowStart = ((scenes.length - 1) ~/ cols) * cols;
      final index = dir < 0 ? lastRowStart + col : col;
      return select(scenes[math.min(index, scenes.length - 1)]);
    }

    final i = scenes.indexOf(current);
    final next = i + dir * cols;
    if (next >= 0 && next < scenes.length) return select(scenes[next]);
    final slot = (i % cols) * 2 < cols ? 0 : others.length - 1;
    select(others[slot]);
  }
}
