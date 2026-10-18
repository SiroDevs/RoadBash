/// One looping layer: a train of exhaust pulses firing at [fireHz].
/// [bright] (0..1) makes each pulse shorter, noisier and less filtered, which
/// is what turns a lazy low-rpm putt into a high-rpm howl.
class EngineLayerSpec {
  const EngineLayerSpec(this.fireHz, this.bright, this.seed);

  final double fireHz;
  final double bright;
  final int seed;
}

/// Every number that gives an engine its character. Per-layer values are
/// `base + slope * bright`, so the brighter layers can change more.
class EngineTune {
  const EngineTune({
    required this.layers,
    this.pattern = const [1.0, 0.78],
    this.jitter = 0.07,
    this.decay = 5.0,
    this.decayBright = 25.0,
    this.ring = 1.6,
    this.ringBright = 8.0,
    this.noiseDecay = 20.0,
    this.noiseDecayBright = 30.0,
    this.noiseGain = 0.20,
    this.noiseGainBright = 0.40,
    this.smooth = 0.18,
    this.smoothBright = 0.78,
    this.drive = 1.5,
    this.driveBright = 1.0,
    this.levels = 255,
    this.hold = 1,
    this.fireMin = 26,
    this.fireSpan = 190,
    this.shiftUp = 0.15,
    this.shiftDown = 0.10,
    this.duckDepth = 0.35,
    this.limiterHz = 17,
    this.limiterDepth = 0.018,
    this.coastLoad = 0.5,
    this.trim = 1.0,
  });

  // ---- the sound itself (read by EngineWave)

  /// The three loops, from the lowest pitch to the highest.
  final List<EngineLayerSpec> layers;

  /// Relative strength of each pulse in turn: [1, 0.78] is a twin, four
  /// numbers make a four-cylinder. Smaller gaps sound smoother.
  final List<double> pattern;

  /// Random variation per pulse (0 = a perfect machine).
  final double jitter;

  /// How fast each thump dies away, and the hum inside it.
  final double decay;
  final double decayBright;
  final double ring;
  final double ringBright;

  /// The crackle that rides on each thump.
  final double noiseDecay;
  final double noiseDecayBright;
  final double noiseGain;
  final double noiseGainBright;

  /// Low-pass filter: lower is duller and more muffled.
  final double smooth;
  final double smoothBright;

  /// How hard the sound is squashed: higher is fuzzier.
  final double drive;
  final double driveBright;

  /// Steps per side of the output (255 = 9-bit, 15 = 4-bit), and how many
  /// samples each value is held for. Both add retro grit.
  final int levels;
  final int hold;

  // ---- how it behaves (read by EngineVoice)

  /// Firing frequency in Hz at rpm 0, and how much rpm 1 adds to it.
  final double fireMin;
  final double fireSpan;

  /// Seconds the sound dips for on an upshift or downshift, and how low.
  final double shiftUp;
  final double shiftDown;
  final double duckDepth;

  /// Rev-limiter flutter in top gear.
  final double limiterHz;
  final double limiterDepth;

  /// Loudness off the throttle, and a per-flavour volume trim.
  final double coastLoad;
  final double trim;
}
