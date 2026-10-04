part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _HomeState;

  const factory HomeState.loaded() = Loaded;

  const factory HomeState.loading() = Loading;

  const factory HomeState.success() = Success;

  const factory HomeState.failure(String failure) = Failure;

}
