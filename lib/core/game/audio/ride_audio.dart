// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/player_profile.dart';
import '../../audio/audio_catalog.dart';
import '../../audio/audio_service.dart';
import '../../audio/loop_player.dart';
import '../../audio/synth/engine_synth.dart';
import '../race/race_controller.dart';
import '../road/road_renderer.dart';

class RideAudio {
  RideAudio({
    required this.mix,
    required this.service,
    required this.road,
    required this.race,
    this.useAssetLoops = false,
  });

  /// Replaced live when the player flips a sound switch mid-race.
  PlayerProfile mix;
  final AudioService service;
  final RoadRenderer road;
  final RaceController race;

  /// Skid, gravel and wind still come from audio/loops/*.wav. Leave this off
  /// until those files exist; the engine never needs them.
  final bool useAssetLoops;

  late final _engine = EngineSynth(mix.flavour);
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

  double get _fx => mix.effectsGain;

  List<LoopPlayer> get _loops => [_skid, _gravel, _wind];

  Future<void> start() => Future.wait([
        _engine.start(),
        if (useAssetLoops) ..._loops.map((p) => p.start()),
      ]);

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

    final k = math.min(1.0, dt * 12);
    _skidLevel += ((road.skidding ? 1.0 : 0.0) - _skidLevel) * k;
    _gravelLevel += ((road.offRoad ? 1.0 : 0.0) - _gravelLevel) * k;

    _acc += dt;
    if (_acc < 0.07) return;
    _acc = 0;
    final sp = road.speedPercent;
    _skid.set(volume: _clamp(_fx * _skidLevel));
    _gravel.set(volume: _clamp(_fx * _gravelLevel * math.min(1.0, sp * 2)));
    _wind.set(volume: _clamp(_fx * sp * 0.5), rate: 0.8 + 0.5 * sp);
  }

  void _events() {
    if (race.countdown > 0) {
      final n = race.countdown.ceil();
      if (n != _count) {
        _count = n;
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

  static double _clamp(double v) => math.min(1.0, math.max(0.0, v));

  void pause() {
    _engine.pause();
    for (final p in _loops) {
      p.pause();
    }
  }

  void resume() {
    _engine.resume();
    for (final p in _loops) {
      p.resume();
    }
  }

  Future<void> dispose() => Future.wait([
        _engine.dispose(),
        ..._loops.map((p) => p.dispose()),
      ]);
}
