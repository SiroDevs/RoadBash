// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/player_profile.dart';
import '../../domain/repos/profile_repo.dart';
import 'settings_state.dart';

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

  /// Emits at once but writes to the database after the user stops dragging.
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
