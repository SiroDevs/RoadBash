// Dart imports:
import 'dart:math' as math;
import 'dart:typed_data';

/// One engine layer: a train of exhaust pulses firing at [fireHz].
/// [bright] (0..1) makes each pulse shorter, noisier and less filtered, which
/// is what turns a lazy low-rpm putt into a high-rpm howl.
class EngineLayerSpec {
  const EngineLayerSpec(this.fireHz, this.bright, this.seed);

  final double fireHz;
  final double bright;
  final int seed;
}

/// A rendered loop. [baseHz] is the firing rate it really has: the period is
/// rounded to a whole number of samples so the loop repeats without a click.
class EngineLoop {
  const EngineLoop(this.wav, this.baseHz);

  final Uint8List wav;
  final double baseHz;
}

/// Builds the engine sound in code, so no engine audio asset is needed.
///
/// Three loops (low, mid, high) are rendered once. At run time the game
/// plays them at a rate that puts their pulses exactly at the engine's
/// firing frequency, and crossfades between them, so the tone gets brighter
/// as the revs climb instead of just getting higher.
abstract final class EngineWave {
  static const int sampleRate = 22050;
  static const double _loopSeconds = 0.7;

  /// Average loudness each loop is scaled to before soft-clipping.
  static const double _targetRms = 0.32;

  static const List<EngineLayerSpec> layers = [
    EngineLayerSpec(48, 0.15, 7),
    EngineLayerSpec(88, 0.55, 8),
    EngineLayerSpec(160, 0.95, 9),
  ];

  static List<EngineLoop>? _loops;

  static List<EngineLoop> get loops => _loops ??= layers.map(_render).toList();

  static EngineLoop _render(EngineLayerSpec s) {
    final period = (sampleRate / s.fireHz).round();
    final pulses = (_loopSeconds * s.fireHz).round();
    final length = period * pulses;
    final rng = math.Random(s.seed);

    final decay = 5.0 + 22.0 * s.bright;
    final ring = 1.6 + 6.0 * s.bright;
    final noiseDecay = 14.0 + 30.0 * s.bright;
    final noiseGain = 0.20 + 0.40 * s.bright;

    // Every other pulse is a little weaker, like a twin, plus a touch of
    // jitter so it does not sound like a perfect machine.
    final amp = List<double>.generate(
      pulses,
      (k) => (k.isEven ? 1.0 : 0.78) * (1 + 0.07 * (rng.nextDouble() * 2 - 1)),
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

    // One-pole low-pass, run twice over the loop so its end flows into its
    // start. Only the second pass is kept.
    final a = 0.18 + 0.78 * s.bright;
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

    // Pulse trains have tall peaks but little average energy, so they sound
    // quiet next to music. Scale by RMS (average loudness) and soft-clip the
    // peaks, which makes all three layers equally loud and a lot fuller.
    final drive = (1.5 + 1.0 * s.bright) * _targetRms / rms;
    var peak = 1e-9;
    for (var i = 0; i < length; i++) {
      f[i] = _tanh(drive * f[i]);
      peak = math.max(peak, f[i].abs());
    }

    // 9-bit steps: the Mega Drive's DAC resolution, for a bit of grit.
    final pcm = Int16List(length);
    for (var i = 0; i < length; i++) {
      final q = (0.95 * f[i] / peak * 255).round() / 255;
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
