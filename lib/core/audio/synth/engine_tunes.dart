// Project imports:
import '../../../domain/models/engine_flavour.dart';
import 'engine_tune.dart';

abstract final class EngineTunes {
  static EngineTune of(EngineFlavour f) => switch (f) {
        EngineFlavour.classic => _classic,
        EngineFlavour.vTwin => _vTwin,
        EngineFlavour.superbike => _superbike,
        EngineFlavour.twoStroke => _twoStroke,
        EngineFlavour.arcade => _arcade,
      };

  static const _classic = EngineTune(
    layers: [
      EngineLayerSpec(48, 0.15, 7),
      EngineLayerSpec(88, 0.8, 8),
      EngineLayerSpec(160, 0.95, 9),
    ],
  );

  static const _vTwin = EngineTune(
    layers: [
      EngineLayerSpec(30, 0.10, 17),
      EngineLayerSpec(60, 0.40, 18),
      EngineLayerSpec(110, 0.80, 19),
    ],
    pattern: [1.0, 0.5],
    jitter: 0.10,
    decay: 3.0,
    decayBright: 14.0,
    ring: 1.1,
    ringBright: 3.5,
    noiseGain: 0.12,
    noiseGainBright: 0.25,
    smooth: 0.10,
    smoothBright: 0.55,
    drive: 2.0,
    driveBright: 0.8,
    fireMin: 16,
    fireSpan: 125,
    shiftUp: 0.22,
    shiftDown: 0.12,
    duckDepth: 0.30,
    limiterHz: 11,
    limiterDepth: 0.03,
    trim: 0.80,
  );

  static const _superbike = EngineTune(
    layers: [
      EngineLayerSpec(80, 0.30, 27),
      EngineLayerSpec(150, 0.70, 28),
      EngineLayerSpec(280, 1.0, 29),
    ],
    pattern: [1.0, 0.95, 0.98, 0.93],
    jitter: 0.03,
    decay: 8.0,
    decayBright: 30.0,
    ring: 2.5,
    ringBright: 8.0,
    noiseGain: 0.10,
    noiseGainBright: 0.22,
    smooth: 0.30,
    smoothBright: 0.65,
    drive: 1.3,
    driveBright: 0.8,
    fireMin: 40,
    fireSpan: 340,
    shiftUp: 0.09,
    shiftDown: 0.06,
    duckDepth: 0.70,
    limiterHz: 24,
    limiterDepth: 0.012,
  );

  static const _twoStroke = EngineTune(
    layers: [
      EngineLayerSpec(60, 0.30, 37),
      EngineLayerSpec(110, 0.70, 38),
      EngineLayerSpec(200, 1.0, 39),
    ],
    pattern: [1.0],
    jitter: 0.20,
    decay: 9.0,
    decayBright: 25.0,
    ring: 4.0,
    ringBright: 10.0,
    noiseDecay: 10.0,
    noiseDecayBright: 22.0,
    noiseGain: 0.45,
    noiseGainBright: 0.45,
    smooth: 0.35,
    smoothBright: 0.60,
    drive: 2.2,
    driveBright: 0.8,
    fireMin: 30,
    fireSpan: 260,
    shiftUp: 0.12,
    shiftDown: 0.07,
    duckDepth: 0.45,
    limiterHz: 30,
    limiterDepth: 0.03,
  );

  static const _arcade = EngineTune(
    layers: [
      EngineLayerSpec(48, 0.10, 47),
      EngineLayerSpec(90, 0.50, 48),
      EngineLayerSpec(170, 0.90, 49),
    ],
    pattern: [1.0],
    jitter: 0.0,
    decay: 1.2,
    decayBright: 4.0,
    ring: 0.5,
    ringBright: 0.8,
    noiseGain: 0.04,
    noiseGainBright: 0.06,
    smooth: 0.9,
    smoothBright: 0.1,
    drive: 7.0,
    driveBright: 0.0,
    levels: 15,
    hold: 3,
    shiftUp: 0.14,
    shiftDown: 0.08,
    duckDepth: 0.10,
    limiterHz: 14,
    limiterDepth: 0.0,
    trim: 0.35,
  );
}
