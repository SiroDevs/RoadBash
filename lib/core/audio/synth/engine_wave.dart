// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';

// Project imports:
import '../../../domain/models/engine_flavour.dart';
import 'engine_tune.dart';
import 'engine_tunes.dart';

/// A rendered engine loop and its base pitch.
class EngineLoop {
  const EngineLoop(this.wav, this.baseHz);

  final Uint8List wav;
  final double baseHz;
}

/// Renders the engine loop audio.
abstract final class EngineWave {
  static const int sampleRate = 22050;
  static const double _loopSeconds = 0.5;

  static const double _targetRms = 0.32;

  static final Map<EngineFlavour, List<EngineLoop>> _cache = {};

  /// Returns the loops of a flavour, rendering them once.
  static List<EngineLoop> loopsFor(EngineFlavour flavour) {
    final tune = EngineTunes.of(flavour);
    return _cache[flavour] ??= [
      for (final spec in tune.layers) _render(tune, spec),
    ];
  }

  /// Renders one engine layer as a looping wave.
  static EngineLoop _render(EngineTune tune, EngineLayerSpec spec) {
    final period = (sampleRate / spec.fireHz).round();
    final cycle = tune.pattern.length;
    final pulses = math.max(
      cycle,
      (_loopSeconds * spec.fireHz / cycle).round() * cycle,
    );
    final length = period * pulses;
    final rng = math.Random(spec.seed);

    final decay = tune.decay + tune.decayBright * spec.bright;
    final ring = tune.ring + tune.ringBright * spec.bright;
    final noiseDecay = tune.noiseDecay + tune.noiseDecayBright * spec.bright;
    final noiseGain = tune.noiseGain + tune.noiseGainBright * spec.bright;

    final amp = List<double>.generate(
      pulses,
      (k) =>
          tune.pattern[k % cycle] * (1 + tune.jitter * (rng.nextDouble() * 2 - 1)),
    );

    final samples = Float64List(length);
    for (var i = 0; i < length; i++) {
      final pulse = i ~/ period;
      final phase = (i - pulse * period) / period;
      final thump = math.exp(-decay * phase) * math.sin(2 * math.pi * ring * phase);
      final click =
          math.exp(-noiseDecay * phase) * (rng.nextDouble() * 2 - 1) * noiseGain;
      samples[i] = amp[pulse] * (thump + click);
    }

    final smoothing = (tune.smooth + tune.smoothBright * spec.bright)
        .clamp(0.02, 1.0)
        .toDouble();
    final filtered = Float64List(length);
    var state = 0.0;
    for (var pass = 0; pass < 2; pass++) {
      for (var i = 0; i < length; i++) {
        state += smoothing * (samples[i] - state);
        filtered[i] = state;
      }
    }

    var mean = 0.0;
    for (final v in filtered) {
      mean += v;
    }
    mean /= length;

    var energy = 0.0;
    for (var i = 0; i < length; i++) {
      filtered[i] -= mean;
      energy += filtered[i] * filtered[i];
    }
    final rms = math.sqrt(energy / length) + 1e-9;

    final drive = (tune.drive + tune.driveBright * spec.bright) * _targetRms / rms;
    for (var i = 0; i < length; i++) {
      filtered[i] = _tanh(drive * filtered[i]);
    }

    if (tune.hold > 1) {
      for (var i = 0; i < length; i++) {
        filtered[i] = filtered[i - i % tune.hold];
      }
    }

    var peak = 1e-9;
    for (final v in filtered) {
      peak = math.max(peak, v.abs());
    }

    final pcm = Int16List(length);
    for (var i = 0; i < length; i++) {
      final quantised = (0.95 * filtered[i] / peak * tune.levels).round() / tune.levels;
      pcm[i] = (quantised * 32767).round();
    }
    return EngineLoop(_wav(pcm), sampleRate / period);
  }

  /// Smooth saturation curve.
  static double _tanh(double value) {
    final exponent = math.exp(2 * value.clamp(-20.0, 20.0));
    return (exponent - 1) / (exponent + 1);
  }

  /// Wraps raw samples in a WAV file.
  static Uint8List _wav(Int16List pcm) {
    final data = pcm.lengthInBytes;
    final bytes = ByteData(44 + data);
    void tag(int at, String text) {
      for (var i = 0; i < 4; i++) {
        bytes.setUint8(at + i, text.codeUnitAt(i));
      }
    }

    tag(0, 'RIFF');
    bytes.setUint32(4, 36 + data, Endian.little);
    tag(8, 'WAVE');
    tag(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little); // PCM
    bytes.setUint16(22, 1, Endian.little); // mono
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, sampleRate * 2, Endian.little);
    bytes.setUint16(32, 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    tag(36, 'data');
    bytes.setUint32(40, data, Endian.little);
    for (var i = 0; i < pcm.length; i++) {
      bytes.setInt16(44 + i * 2, pcm[i], Endian.little);
    }
    return bytes.buffer.asUint8List();
  }
}
