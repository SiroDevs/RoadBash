// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Tabs available on the reception screen.
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

/// Remembers which reception tab is open.
@injectable
class ReceptionCubit extends Cubit<ReceptionTab> {
  ReceptionCubit() : super(ReceptionTab.name);

  /// Switches to the given reception tab.
  void open(ReceptionTab tab) => emit(tab);
}
