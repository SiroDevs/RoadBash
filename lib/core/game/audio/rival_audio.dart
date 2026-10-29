import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../domain/models/engine_flavour.dart';
import '../../audio/synth/engine_synth.dart';
import '../../audio/synth/engine_tunes.dart';
import '../../audio/synth/engine_voice.dart';
import '../../audio/synth/engine_wave.dart';
import '../race/race_controller.dart';
import '../race/rival_racer.dart';
import '../road/config/road_config.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';

class _RivalVoice {
  _RivalVoice(this.racer, this.flavour, this.loop)
      : voice = EngineVoice([loop.baseHz], EngineTunes.of(flavour));

  final RivalRacer racer;
  final EngineFlavour flavour;
  final EngineLoop loop;
  final EngineVoice voice;

  SoundHandle? handle;
  double doppler = 1, volume = -1, pan = 2, rate = 1;
}

class RivalAudio {
  RivalAudio(
    List<RivalRacer> racers,
    this.road,
    this.race,
    EngineFlavour playerFlavour,
  ) {
    final others = [
      for (final f in EngineFlavour.values)
        if (f != playerFlavour) f,
    ];
    for (final r in racers) {
      final flavour = others[r.index % others.length];
      final loops = EngineWave.loopsFor(flavour);
      _voices.add(_RivalVoice(r, flavour, loops[loops.length ~/ 2]));
    }
  }

  static const double _tick = 0.03;
  static const double _gain = 0.75;
  static const double _near = 1500;
  static const double _far = 16000;
  static const double _soundSpeed = 343;
  static const double _unitsPerMetre =
      VehicleConfig.maxSpeed / (VehicleConfig.topSpeedKmh / 3.6);

  final RoadRenderer road;
  final RaceController race;
  final List<_RivalVoice> _voices = [];
  final Map<String, AudioSource> _sources = {};
  double _acc = 0;
  bool _disposed = false;

  Future<void> start() async {
    if (_voices.isEmpty || !await EngineSynth.ensureReady()) return;
    final so = SoLoud.instance;
    for (final v in _voices) {
      try {
        final key = 'rival-${v.flavour.id}-${v.loop.baseHz.round()}hz.wav';
        var source = _sources[key];
        source ??= await so.loadMem(key, v.loop.wav, mode: LoadMode.memory);
        _sources[key] = source;
        if (_disposed) return dispose();
        v.handle = so.play(source, volume: 0, looping: true);
      } catch (e) {
        debugPrint('[rival-engine] could not start: $e');
      }
    }
    if (_disposed) await dispose();
  }

  void update(double dt, {required double volume}) {
    _acc += dt;
    if (_acc < _tick) return;
    final step = _acc;
    _acc = 0;
    for (final v in _voices) {
      if (v.handle != null) _tune(v, step, volume);
    }
  }

  void _tune(_RivalVoice v, double step, double volume) {
    final r = v.racer;
    final grid = race.countdown > 0;
    final stopped = r.speed < VehicleConfig.stoppedSpeed;
    final sp = (r.speed / VehicleConfig.maxSpeed).clamp(0.0, 1.0).toDouble();
    const gears = 6;
    final gear = math.min(gears, 1 + (sp * gears).floor());
    final inGear = (sp * gears - (gear - 1)).clamp(0.0, 1.0).toDouble();
    final rpm = grid ? 0.32 : (stopped ? 0.16 : 0.28 + 0.72 * inGear);

    v.voice.update(
      step,
      rpm: rpm,
      gear: gear,
      throttle: grid || (!r.braking && !stopped),
      brake: r.braking,
      locked: grid,
      stopped: stopped && !grid,
    );

    final dz = r.distance - road.fullDistance;
    final side = (r.lateral - road.playerX) * RoadConfig.roadWidth;
    final dist = math.sqrt(dz * dz + side * side);
    final cut = (1 - dist / _far).clamp(0.0, 1.0).toDouble();
    final heard = cut * cut / (1 + dist / _near) * (dz < 0 ? 0.85 : 1.0);

    final ahead = _tanh(dz / 500);
    final closing = ahead * (r.speed - road.speed) / _unitsPerMetre;
    final shift = (_soundSpeed / (_soundSpeed + closing)).clamp(0.7, 1.4).toDouble();
    v.doppler += (shift - v.doppler) * math.min(1.0, step * 12);

    final vol = (volume * _gain * v.voice.volumes[0] * heard).clamp(0.0, 1.0).toDouble();
    final pan = (side / math.max(dist, 600.0)).clamp(-1.0, 1.0).toDouble();
    final rate = (v.voice.rates[0] * v.doppler).clamp(0.3, 3.0).toDouble();
    _apply(v, vol.toDouble(), pan.toDouble(), rate.toDouble());
  }

  void _apply(_RivalVoice v, double vol, double pan, double rate) {
    final h = v.handle;
    if (h == null) return;
    final so = SoLoud.instance;
    if ((vol - v.volume).abs() > 0.004 || (vol == 0 && v.volume != 0)) {
      v.volume = vol;
      so.setVolume(h, vol);
    }
    if ((pan - v.pan).abs() > 0.01) {
      v.pan = pan;
      so.setPan(h, pan);
    }
    if ((rate - v.rate).abs() > 0.002) {
      v.rate = rate;
      so.setRelativePlaySpeed(h, rate);
    }
  }

  static double _tanh(double x) {
    final e = math.exp(2 * x.clamp(-10.0, 10.0).toDouble());
    return (e - 1) / (e + 1);
  }

  void pause() {
    for (final v in _voices) {
      final h = v.handle;
      if (h != null) SoLoud.instance.setPause(h, true);
    }
  }

  void resume() {
    for (final v in _voices) {
      final h = v.handle;
      if (h != null) SoLoud.instance.setPause(h, false);
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    final handles = [for (final v in _voices) v.handle];
    for (final v in _voices) {
      v.handle = null;
    }
    final sources = _sources.values.toList();
    _sources.clear();
    if (!SoLoud.instance.isInitialized) return;
    try {
      for (final h in handles) {
        if (h != null) await SoLoud.instance.stop(h);
      }
      for (final s in sources) {
        await SoLoud.instance.disposeSource(s);
      }
    } catch (_) {}
  }
}
