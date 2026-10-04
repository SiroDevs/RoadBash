import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.dart';
part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const _HomeState()) {
    on<FetchLocation>(_onFetchLocation);
  }

  // final _homeRepo = HomeRepository();

  void _onFetchLocation(
    FetchLocation event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());

  }
}
