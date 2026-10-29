// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/audio/sound_player.dart';
import '../../../domain/models/player_profile.dart';
import '../../settings/cubit/settings_cubit.dart';
import 'audio_state.dart';

/// Plays music and applies volume changes from settings.
@lazySingleton
class AudioCubit extends Cubit<AudioState>
    with WidgetsBindingObserver
    implements SoundPlayer {
  AudioCubit(this._audio, this._settings) : super(const AudioState()) {
    WidgetsBinding.instance.addObserver(this);
    _sub = _settings.stream.listen((_) => _applyVolume());
  }

  final AudioService _audio;
  final SettingsCubit _settings;
  late final StreamSubscription<dynamic> _sub;

  /// Returns the current audio mix from the profile.
  PlayerProfile get _mix => _settings.state.profile;

  /// Returns the volume for a music track.
  double _musicVolume(MusicTrack track) => _mix.musicGain * track.gain;

  @override
  Future<void> playMusic(MusicTrack track) async {
    emit(AudioState(track: track));
    await _audio.playMusic(track, _musicVolume(track));
  }

  @override
  void sfx(Sfx sfx) => _audio.playSfx(sfx, _mix.effectsGain);

  /// Re-applies the current music volume.
  void _applyVolume() {
    final track = state.track;
    if (track != null) _audio.setMusicVolume(_musicVolume(track));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
