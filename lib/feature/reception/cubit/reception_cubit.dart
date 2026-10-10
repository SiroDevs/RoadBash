// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum ReceptionTab { name, sound, controls }

/// Which reception item is open on the right-hand panel.
@injectable
class ReceptionCubit extends Cubit<ReceptionTab> {
  ReceptionCubit() : super(ReceptionTab.name);

  void open(ReceptionTab tab) => emit(tab);
}
