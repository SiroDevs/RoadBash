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
}
