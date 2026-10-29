// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/player_profile.dart';
import '../../audio/audio_catalog.dart';
import '../../audio/audio_service.dart';
import '../../audio/loop_player.dart';
import '../../audio/synth/engine_synth.dart';
import '../race/race_controller.dart';
import '../race/rival_racer.dart';
import '../road/road_renderer.dart';
import 'rival_audio.dart';

/// Plays engine, skid, gravel, wind and countdown sounds during a race.
class RideAudio {
  RideAudio({
    required this.mix,
    required this.service,
    required this.road,
    required this.race,
    this.racers = const [],
    this.useAssetLoops = false,
  });

  PlayerProfile mix;
  final AudioService service;
  final RoadRenderer road;
  final RaceController race;

  final List<RivalRacer> racers;
  final bool useAssetLoops;

  late final _engine = EngineSynth(mix.flavour);
  late final _rivals = RivalAudio(racers, road, race, mix.flavour);
  final _skid = LoopPlayer(LoopSound.skid.asset);
  final _gravel = LoopPlayer(LoopSound.gravel.asset);
  final _wind = LoopPlayer(LoopSound.wind.asset);

  double _acc = 0;
  double _skidLevel = 0;
  double _gravelLevel = 0;
  int _count = 4;
  int _gear = 1;
  bool _wentGo = false;
  bool _wasFinished = false;
  bool? _wasOnFoot;

  /// Effects volume from the current mix.
  double get _fx => mix.effectsGain;

  /// Looping effect players.
  List<LoopPlayer> get _loops => [_skid, _gravel, _wind];

  /// Starts all audio loops.
  Future<void> start() => Future.wait([
        _engine.start(),
        _rivals.start(),
        if (useAssetLoops) ..._loops.map((p) => p.start()),
      ]);

  /// Updates the sounds from the bike's state each frame.
  void update(double dt) {
    _events();
    _engine.update(
      dt,
      volume: mix.engineGain,
      rpm: road.rpm,
      gear: road.gear,
      throttle: road.throttle,
      brake: road.brake,
      locked: road.locked,
      stopped: road.stopped,
    );

    _rivals.update(dt, volume: mix.engineGain);

    final blend = math.min(1.0, dt * 12);
    _skidLevel += ((road.skidding ? 1.0 : 0.0) - _skidLevel) * blend;
    _gravelLevel += ((road.offRoad ? 1.0 : 0.0) - _gravelLevel) * blend;

    _acc += dt;
    if (_acc < 0.07) return;
    _acc = 0;
    final sp = road.speedPercent;
    _skid.set(volume: _clamp(_fx * _skidLevel));
    _gravel.set(volume: _clamp(_fx * _gravelLevel * math.min(1.0, sp * 2)));
    _wind.set(volume: _clamp(_fx * sp * 0.5), rate: 0.8 + 0.5 * sp);
  }

  /// Plays one-shot sounds such as the countdown.
  void _events() {
    if (race.countdown > 0) {
      final seconds = race.countdown.ceil();
      if (seconds != _count) {
        _count = seconds;
        service.playSfx(Sfx.beep, _fx);
      }
    } else if (!_wentGo) {
      _wentGo = true;
      service.playSfx(Sfx.go, _fx);
    }
    if (road.gear > _gear && !road.locked) {
      service.playSfx(Sfx.shift, _fx * 0.6);
    }
    _gear = road.gear;

    if (race.finished && !_wasFinished) service.playSfx(Sfx.finish, _fx);
    _wasFinished = race.finished;

    final onFoot = road.restingOnFoot;
    if (_wasOnFoot == false && onFoot) service.playSfx(Sfx.foot, _fx);
    _wasOnFoot = onFoot;
  }

  /// Clamps a value between 0 and 1.
  static double _clamp(double value) => math.min(1.0, math.max(0.0, value));

  /// Pauses all race audio.
  void pause() {
    _engine.pause();
    _rivals.pause();
    for (final p in _loops) {
      p.pause();
    }
  }

  /// Resumes all race audio.
  void resume() {
    _engine.resume();
    _rivals.resume();
    for (final p in _loops) {
      p.resume();
    }
  }

  /// Releases all audio resources.
  Future<void> dispose() => Future.wait([
        _engine.dispose(),
        _rivals.dispose(),
        ..._loops.map((p) => p.dispose()),
      ]);
}
