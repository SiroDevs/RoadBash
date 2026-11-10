// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flame/game.dart';

// Project imports:
import '../audio/ride_audio.dart';
import '../input/road_input.dart';

/// Pausing a race from the menu or when the app leaves the foreground.
mixin RacePause on FlameGame, RoadInput {
  /// The ride audio that follows the pause, once it exists.
  RideAudio? get ride;

  bool _menuPaused = false;

  /// True while the race is paused from the menu.
  bool get menuPaused => _menuPaused;

  /// Pauses the race and silences input and audio.
  void pauseRace() {
    if (_menuPaused) return;
    _menuPaused = true;
    clearInput();
    pauseEngine();
    ride?.pause();
  }

  /// Resumes a race paused from the menu.
  void resumeRace() {
    if (!_menuPaused) return;
    _menuPaused = false;
    resumeEngine();
    ride?.resume();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (_menuPaused) return;
    if (state == AppLifecycleState.resumed) {
      ride?.resume();
    } else {
      ride?.pause();
    }
  }
}
