// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/player_profile.dart';
import '../../audio/audio_catalog.dart';
import '../../audio/audio_service.dart';
import '../../audio/loop_player.dart';
import '../race/race_controller.dart';
import '../road/road_renderer.dart';

/// Engine, tyre, gravel and wind loops plus the race one-shots (countdown,
/// gear shifts, foot down, finish). Audio is optional: failures stay silent.
class RideAudio {
  RideAudio({
    required this.mix,
    required this.service,
    required this.road,
    required this.race,
  });

  final PlayerProfile mix;
  final AudioService service;
  final RoadRenderer road;
  final RaceController race;

  final _engine = LoopPlayer(LoopSound.engine.asset);
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

  double get _fx => mix.master * mix.effects;

  Future<void> start() =>
      Future.wait([_engine, _skid, _gravel, _wind].map((p) => p.start()));

  void update(double dt) {
    _events();
    final k = math.min(1.0, dt * 12);
    _skidLevel += ((road.skidding ? 1.0 : 0.0) - _skidLevel) * k;
    _gravelLevel += ((road.offRoad ? 1.0 : 0.0) - _gravelLevel) * k;

    _acc += dt;
    if (_acc < 0.07) return;
    _acc = 0;
    final sp = road.speedPercent;
    _engine.set(
      volume: _clamp(mix.master * mix.engine * (0.35 + 0.65 * road.engineLoad)),
      rate: 0.6 + 1.3 * road.rpm,
    );
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
    if (road.gear > _gear && !road.locked) service.playSfx(Sfx.shift, _fx * 0.6);
    _gear = road.gear;

    if (race.finished && !_wasFinished) service.playSfx(Sfx.finish, _fx);
    _wasFinished = race.finished;

    final onFoot = road.restingOnFoot;
    if (_wasOnFoot == false && onFoot) service.playSfx(Sfx.foot, _fx);
    _wasOnFoot = onFoot;
  }

  static double _clamp(double v) => math.min(1.0, math.max(0.0, v));

  void pause() {
    for (final p in [_engine, _skid, _gravel, _wind]) {
      p.pause();
    }
  }

  void resume() {
    for (final p in [_engine, _skid, _gravel, _wind]) {
      p.resume();
    }
  }

  Future<void> dispose() =>
      Future.wait([_engine, _skid, _gravel, _wind].map((p) => p.dispose()));
}
