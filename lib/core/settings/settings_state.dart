part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({this.profile = const PlayerProfile(), this.loaded = false});

  final PlayerProfile profile;
  final bool loaded;

  @override
  List<Object?> get props => [profile, loaded];
}
