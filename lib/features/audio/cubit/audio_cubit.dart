// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../domain/models/player_profile.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../audio_catalog.dart';
import '../audio_service.dart';
import 'audio_state.dart';

/// Owns background music and UI sounds, and follows the volume settings.
@lazySingleton
class AudioCubit extends Cubit<AudioState> with WidgetsBindingObserver {
  AudioCubit(this._audio, this._settings) : super(const AudioState()) {
    WidgetsBinding.instance.addObserver(this);
    _sub = _settings.stream.listen((_) => _applyVolume());
  }

  final AudioService _audio;
  final SettingsCubit _settings;
  late final StreamSubscription<dynamic> _sub;

  PlayerProfile get _mix => _settings.state.profile;

  double _musicVolume(MusicTrack t) => _mix.master * _mix.music * t.gain;

  Future<void> playMusic(MusicTrack track) async {
    emit(AudioState(track: track));
    await _audio.playMusic(track, _musicVolume(track));
  }

  void sfx(Sfx sfx) => _audio.playSfx(sfx, _mix.master * _mix.effects);

  void _applyVolume() {
    final track = state.track;
    if (track != null) _audio.setMusicVolume(_musicVolume(track));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.resumed) {
      _audio.resume();
    } else {
      _audio.pause();
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _sub.cancel();
    return super.close();
  }
}
