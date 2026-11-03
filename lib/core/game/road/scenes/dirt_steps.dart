/// One piece of road: easing into, holding and leaving a bend and a hill.
class RoadStep {
  const RoadStep(this.enter, this.hold, this.leave, this.curve, this.hill);

  final int enter;
  final int hold;
  final int leave;
  final double curve;
  final double hill;
}

/// The dirt road: long bends, steep climbs and drops, and a flat finish.
const List<RoadStep> dirtSteps = [
  RoadStep(40, 60, 40, 0, 0),
  RoadStep(50, 70, 50, 1.6, 12),
  RoadStep(45, 50, 45, -2.4, 8),
  RoadStep(40, 80, 40, 0, -20),
  RoadStep(45, 55, 45, 3.0, -6),
  RoadStep(50, 60, 50, -2.0, 16),
  RoadStep(45, 45, 45, 3.4, 4),
  RoadStep(40, 40, 40, -3.8, -12),
  RoadStep(45, 80, 45, 0, 24),
  RoadStep(40, 60, 40, 2.2, -24),
  RoadStep(45, 50, 45, -2.8, 0),
  RoadStep(40, 60, 40, 3.6, 10),
  RoadStep(45, 50, 45, -3.2, -10),
  RoadStep(50, 90, 50, 0, 18),
  RoadStep(45, 50, 45, 2.6, -18),
  RoadStep(40, 50, 40, -4.0, 6),
  RoadStep(45, 70, 45, 1.8, -8),
  RoadStep(50, 70, 50, 0, 26),
  RoadStep(45, 70, 45, -2.4, -26),
  RoadStep(40, 50, 40, 3.2, 8),
  RoadStep(45, 45, 45, -3.6, -8),
  RoadStep(45, 90, 45, 0, 14),
  RoadStep(40, 60, 40, 2.8, -14),
  RoadStep(45, 60, 45, -2.2, 0),
  RoadStep(40, 50, 40, 4.0, 12),
  RoadStep(45, 60, 45, -3.0, -20),
  RoadStep(50, 80, 50, 1.4, 20),
  RoadStep(45, 60, 45, -1.8, -22),
  RoadStep(45, 70, 45, 0, 0),
  RoadStep(60, 300, 60, 0, 0),
];
