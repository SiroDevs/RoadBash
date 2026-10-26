// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum ReceptionTab {
  name,
  sound,
  controls,
  language,
  stats,
  leaderboard,
  suggestions,
  exit,
}

@injectable
class ReceptionCubit extends Cubit<ReceptionTab> {
  ReceptionCubit() : super(ReceptionTab.name);

  void open(ReceptionTab tab) => emit(tab);
}
