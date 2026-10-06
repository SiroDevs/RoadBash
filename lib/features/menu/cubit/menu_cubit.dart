// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Which menu entry is highlighted: 0 city, 1 suburbs, 2 reception.
@injectable
class MenuCubit extends Cubit<int> {
  MenuCubit() : super(0);

  static const entries = 3;

  void move(int delta) => emit((state + delta) % entries);

  void select(int index) => emit(index);
}
