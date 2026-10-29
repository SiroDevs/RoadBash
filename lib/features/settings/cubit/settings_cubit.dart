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

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsState());

  final ProfileRepo _repo;
  Timer? _saveTimer;

  Future<void> load() async =>
      emit(SettingsState(profile: await _repo.load(), loaded: true));

  void setName(String value) => _update(state.profile.copyWith(name: value));
  void setMaster(double value) => _update(state.profile.copyWith(master: value));
  void setMusic(double value) => _update(state.profile.copyWith(music: value));
  void setEngine(double value) => _update(state.profile.copyWith(engine: value));
  void setEffects(double value) => _update(state.profile.copyWith(effects: value));
  void setFlavour(EngineFlavour value) =>
      _update(state.profile.copyWith(flavour: value));

  void setUseScreenTouch(bool value) =>
      _update(state.profile.copyWith(useScreenTouch: value));
  void setMute(bool value) => _update(state.profile.copyWith(mute: value));
  void setMusicOn(bool value) => _update(state.profile.copyWith(musicOn: value));
  void setEffectsOn(bool value) => _update(state.profile.copyWith(effectsOn: value));
  void setEngineOn(bool value) => _update(state.profile.copyWith(engineOn: value));
  void setInvertTilt(bool value) =>
      _update(state.profile.copyWith(invertTilt: value));
  void setLanguage(String value) => _update(state.profile.copyWith(language: value));

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
