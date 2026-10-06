// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../domain/models/player_profile.dart';

class SettingsState extends Equatable {
  const SettingsState({this.profile = const PlayerProfile(), this.loaded = false});

  final PlayerProfile profile;
  final bool loaded;

  @override
  List<Object?> get props => [profile, loaded];
}
