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

  void setName(String v) => _update(state.profile.copyWith(name: v));
  void setMaster(double v) => _update(state.profile.copyWith(master: v));
  void setMusic(double v) => _update(state.profile.copyWith(music: v));
  void setEngine(double v) => _update(state.profile.copyWith(engine: v));
  void setEffects(double v) => _update(state.profile.copyWith(effects: v));
  void setFlavour(EngineFlavour v) =>
      _update(state.profile.copyWith(flavour: v));

  void setUseScreenTouch(bool v) =>
      _update(state.profile.copyWith(useScreenTouch: v));
  void setMute(bool v) => _update(state.profile.copyWith(mute: v));
  void setMusicOn(bool v) => _update(state.profile.copyWith(musicOn: v));
  void setEffectsOn(bool v) => _update(state.profile.copyWith(effectsOn: v));
  void setEngineOn(bool v) => _update(state.profile.copyWith(engineOn: v));
  void setInvertTilt(bool v) =>
      _update(state.profile.copyWith(invertTilt: v));
  void setLanguage(String v) => _update(state.profile.copyWith(language: v));

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
