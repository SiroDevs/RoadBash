/// Place names on the overhead signs, in route order. A gantry's `tint`
/// picks one of these.
const List<String> thikaSignLabels = [
  'RUIRU',
  'PANGANI',
  'FOREST RD',
  'MUSEUM HILL',
];

/// How one stretch of Thika Rd looks. Everything is a fraction or a range so
/// a stretch can be retuned without touching the layout code.
class ThikaZone {
  const ThikaZone({
    required this.lot,
    required this.storeys,
    required this.setBack,
    required this.treeStep,
    required this.treeSetBack,
    required this.bridgeEvery,
    required this.pines,
  });

  /// Chance that the next thing on a verge is a building, not a tree.
  final double lot;

  /// Min and max storeys.
  final (int, int) storeys;

  /// Building distance from the road, in half-road-widths.
  final (double, double) setBack;

  /// Segments between trees, and how far from the road they stand.
  final (int, int) treeStep;
  final (double, double) treeSetBack;

  /// Segments between footbridges.
  final int bridgeEvery;

  /// Share of trees that are cypress/pine rather than broadleaf.
  final double pines;
}

const List<ThikaZone> thikaZones = [
  // Ruiru: low shops set well back, dry scrub and a few trees.
  ThikaZone(
    lot: 0.45,
    storeys: (1, 3),
    setBack: (1.9, 3.4),
    treeStep: (9, 20),
    treeSetBack: (1.5, 4.5),
    bridgeEvery: 190,
    pines: 0.05,
  ),
  // Pangani: wall to wall mid-rise flats and offices.
  ThikaZone(
    lot: 0.9,
    storeys: (4, 10),
    setBack: (1.42, 1.9),
    treeStep: (14, 26),
    treeSetBack: (1.3, 2.0),
    bridgeEvery: 120,
    pines: 0.1,
  ),
  // Forest Rd: a green tunnel, buildings only glimpsed behind the trees.
  ThikaZone(
    lot: 0.22,
    storeys: (3, 8),
    setBack: (2.8, 4.2),
    treeStep: (4, 9),
    treeSetBack: (1.25, 2.6),
    bridgeEvery: 230,
    pines: 0.4,
  ),
  // Museum Hill: offices and institutions on the rise.
  ThikaZone(
    lot: 0.55,
    storeys: (2, 7),
    setBack: (1.6, 2.6),
    treeStep: (7, 14),
    treeSetBack: (1.4, 3.2),
    bridgeEvery: 200,
    pines: 0.25,
  ),
];

/// Flyovers: (stretch, segments after the stretch starts). Pangani's sits on
/// the climb, the other on the Museum Hill interchange.
const List<(int, int)> thikaFlyovers = [(1, 250), (1, 770), (3, 310)];

int thikaZoneAt(int segment, List<int> starts) {
  var zone = 0;
  for (var z = 0; z < starts.length && z < thikaZones.length; z++) {
    if (segment >= starts[z]) zone = z;
  }
  return zone;
}

double pickIn((double, double) range, double r) =>
    range.$1 + (range.$2 - range.$1) * r;
