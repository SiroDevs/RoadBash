class EngineLayerSpec {
  const EngineLayerSpec(this.fireHz, this.bright, this.seed);

  final double fireHz;
  final double bright;
  final int seed;
}

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

  // Sound

  final List<EngineLayerSpec> layers;

  final List<double> pattern;

  final double jitter;

  final double decay;
  final double decayBright;
  final double ring;
  final double ringBright;

  final double noiseDecay;
  final double noiseDecayBright;
  final double noiseGain;
  final double noiseGainBright;

  final double smooth;
  final double smoothBright;

  final double drive;
  final double driveBright;

  final int levels;
  final int hold;

  // Behaviour

  final double fireMin;
  final double fireSpan;

  final double shiftUp;
  final double shiftDown;
  final double duckDepth;

  final double limiterHz;
  final double limiterDepth;

  final double coastLoad;
  final double trim;
}
