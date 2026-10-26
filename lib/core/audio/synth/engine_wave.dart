// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';

// Project imports:
import '../../../domain/models/engine_flavour.dart';
import 'engine_tune.dart';
import 'engine_tunes.dart';

class EngineLoop {
  const EngineLoop(this.wav, this.baseHz);

  final Uint8List wav;
  final double baseHz;
}

abstract final class EngineWave {
  static const int sampleRate = 22050;
  static const double _loopSeconds = 0.5;

  static const double _targetRms = 0.32;

  static final Map<EngineFlavour, List<EngineLoop>> _cache = {};

  static List<EngineLoop> loopsFor(EngineFlavour flavour) {
    final tune = EngineTunes.of(flavour);
    return _cache[flavour] ??= [
      for (final spec in tune.layers) _render(tune, spec),
    ];
  }

  static EngineLoop _render(EngineTune t, EngineLayerSpec spec) {
    final period = (sampleRate / spec.fireHz).round();
    final cycle = t.pattern.length;
    final pulses = math.max(
      cycle,
      (_loopSeconds * spec.fireHz / cycle).round() * cycle,
    );
    final length = period * pulses;
    final rng = math.Random(spec.seed);

    final decay = t.decay + t.decayBright * spec.bright;
    final ring = t.ring + t.ringBright * spec.bright;
    final noiseDecay = t.noiseDecay + t.noiseDecayBright * spec.bright;
    final noiseGain = t.noiseGain + t.noiseGainBright * spec.bright;

    final amp = List<double>.generate(
      pulses,
      (k) =>
          t.pattern[k % cycle] * (1 + t.jitter * (rng.nextDouble() * 2 - 1)),
    );

    final x = Float64List(length);
    for (var i = 0; i < length; i++) {
      final k = i ~/ period;
      final u = (i - k * period) / period;
      final thump = math.exp(-decay * u) * math.sin(2 * math.pi * ring * u);
      final click =
          math.exp(-noiseDecay * u) * (rng.nextDouble() * 2 - 1) * noiseGain;
      x[i] = amp[k] * (thump + click);
    }

    final a = (t.smooth + t.smoothBright * spec.bright)
        .clamp(0.02, 1.0)
        .toDouble();
    final f = Float64List(length);
    var y = 0.0;
    for (var pass = 0; pass < 2; pass++) {
      for (var i = 0; i < length; i++) {
        y += a * (x[i] - y);
        f[i] = y;
      }
    }

    var mean = 0.0;
    for (final v in f) {
      mean += v;
    }
    mean /= length;

    var energy = 0.0;
    for (var i = 0; i < length; i++) {
      f[i] -= mean;
      energy += f[i] * f[i];
    }
    final rms = math.sqrt(energy / length) + 1e-9;

    final drive = (t.drive + t.driveBright * spec.bright) * _targetRms / rms;
    for (var i = 0; i < length; i++) {
      f[i] = _tanh(drive * f[i]);
    }

    if (t.hold > 1) {
      for (var i = 0; i < length; i++) {
        f[i] = f[i - i % t.hold];
      }
    }

    var peak = 1e-9;
    for (final v in f) {
      peak = math.max(peak, v.abs());
    }

    final pcm = Int16List(length);
    for (var i = 0; i < length; i++) {
      final q = (0.95 * f[i] / peak * t.levels).round() / t.levels;
      pcm[i] = (q * 32767).round();
    }
    return EngineLoop(_wav(pcm), sampleRate / period);
  }

  static double _tanh(double v) {
    final e = math.exp(2 * v.clamp(-20.0, 20.0));
    return (e - 1) / (e + 1);
  }

  static Uint8List _wav(Int16List pcm) {
    final data = pcm.lengthInBytes;
    final b = ByteData(44 + data);
    void tag(int at, String s) {
      for (var i = 0; i < 4; i++) {
        b.setUint8(at + i, s.codeUnitAt(i));
      }
    }

    tag(0, 'RIFF');
    b.setUint32(4, 36 + data, Endian.little);
    tag(8, 'WAVE');
    tag(12, 'fmt ');
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little); // PCM
    b.setUint16(22, 1, Endian.little); // mono
    b.setUint32(24, sampleRate, Endian.little);
    b.setUint32(28, sampleRate * 2, Endian.little);
    b.setUint16(32, 2, Endian.little);
    b.setUint16(34, 16, Endian.little);
    tag(36, 'data');
    b.setUint32(40, data, Endian.little);
    for (var i = 0; i < pcm.length; i++) {
      b.setInt16(44 + i * 2, pcm[i], Endian.little);
    }
    return b.buffer.asUint8List();
  }
}
