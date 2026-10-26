// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/scene_id.dart';

@injectable
class MenuCubit extends Cubit<int> {
  MenuCubit() : super(0);

  static final entries = SceneId.values.length;

  void move(int delta) => emit((state + delta) % entries);

  void select(int index) => emit(index);
}
