// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/engine_flavour.dart';
import '../../../domain/models/player_profile.dart';
import '../../../domain/repos/profile_repo.dart';

part 'settings_state.dart';

/// Holds the player profile and saves changes after a short delay.
@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsState());

  final ProfileRepo _repo;
  Timer? _saveTimer;

  /// Loads the saved profile.
  Future<void> load() async =>
      emit(SettingsState(profile: await _repo.load(), loaded: true));

  /// Sets the player name.
  void setName(String value) => _update(state.profile.copyWith(name: value));
  /// Sets the master volume.
  void setMaster(double value) => _update(state.profile.copyWith(master: value));
  /// Sets the music volume.
  void setMusic(double value) => _update(state.profile.copyWith(music: value));
  /// Sets the engine volume.
  void setEngine(double value) => _update(state.profile.copyWith(engine: value));
  /// Sets the effects volume.
  void setEffects(double value) => _update(state.profile.copyWith(effects: value));
  /// Sets the engine sound style.
  void setFlavour(EngineFlavour value) =>
      _update(state.profile.copyWith(flavour: value));

  /// Chooses on-screen touch controls over tilt steering.
  void setUseScreenTouch(bool value) =>
      _update(state.profile.copyWith(useScreenTouch: value));
  /// Mutes or unmutes all sound.
  void setMute(bool value) => _update(state.profile.copyWith(mute: value));
  /// Turns music on or off.
  void setMusicOn(bool value) => _update(state.profile.copyWith(musicOn: value));
  /// Turns sound effects on or off.
  void setEffectsOn(bool value) => _update(state.profile.copyWith(effectsOn: value));
  /// Turns the engine sound on or off.
  void setEngineOn(bool value) => _update(state.profile.copyWith(engineOn: value));
  /// Inverts the tilt steering direction.
  void setInvertTilt(bool value) =>
      _update(state.profile.copyWith(invertTilt: value));
  /// Sets the app language.
  void setLanguage(String value) => _update(state.profile.copyWith(language: value));

  /// Emits the new profile and schedules a debounced save.
  void _update(PlayerProfile profile) {
    emit(SettingsState(profile: profile, loaded: state.loaded));
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () => _repo.save(profile));
  }

  @override
  Future<void> close() {
    _saveTimer?.cancel();
    return super.close();
  }
}
