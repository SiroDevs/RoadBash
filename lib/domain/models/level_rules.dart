// Project imports:
import 'scene_id.dart';

/// How crowded the road is with civilian traffic.
enum TrafficDensity {
  none(0),
  veryLight(3.0),
  light(1.8),
  moderate(1.25),
  heavy(0.75);

  const TrafficDensity(this.spacingFactor);

  /// Multiplies the gap between vehicles, so a bigger value is an emptier road.
  final double spacingFactor;

  /// True when no civilian vehicle is on the road at all.
  bool get isNone => this == none;
}

/// The rules of one level: what is open, who you race, what is at stake.
///
/// Every number the levels depend on lives in [all], so changing a level is a
/// one-line edit. Money is in Kenya shillings.
class LevelRules {
  const LevelRules({
    required this.level,
    required this.scenes,
    required this.laps,
    required this.rivals,
    required this.maxSpeedKmh,
    required this.winPrize,
    required this.traffic,
    this.trafficFine = 0,
    this.shoving = false,
    this.hospitalBill = 0,
    this.garageBill = 0,
    this.policeFine = 0,
    this.pedestrians = false,
  });

  final int level;

  /// Scenes that can be raced at this level.
  final Set<SceneId> scenes;

  /// Laps per scene where they differ from the scene's own lap count.
  final Map<SceneId, int> laps;

  /// How many rivals line up on the grid.
  final int rivals;

  /// The fastest the player's bike can go.
  final double maxSpeedKmh;

  /// Prize money for a win; 0 means the level pays nothing.
  final int winPrize;

  final TrafficDensity traffic;

  /// Fine for each hit on a civilian vehicle.
  final int trafficFine;

  /// True when bikes can shove each other by side contact.
  final bool shoving;

  /// Hospital bill for a nasty crash; 0 means such a crash is only a tumble.
  final int hospitalBill;

  /// Extra bill for the bike after such a crash; 0 means the bike holds up.
  final int garageBill;

  /// Fine for being busted; 0 means there are no police on the road.
  final int policeFine;

  /// True when pedestrians cross the road in the city.
  final bool pedestrians;

  static const int top = 7;

  /// Wins in a row at a level that unlock the next one.
  static const int winsToAdvance = 2;

  /// Share of the win prize paid for a new best time.
  static const double bestTimeBonus = 0.05;

  /// Share of the win prize paid for a race with no bashing of rivals.
  static const double cleanRaceBonus = 0.03;

  static const Set<SceneId> _starter = {SceneId.city, SceneId.suburbs};
  static const Set<SceneId> _withThika = {
    SceneId.city,
    SceneId.suburbs,
    SceneId.thikaRoad,
  };
  static const Set<SceneId> _everything = {
    SceneId.city,
    SceneId.suburbs,
    SceneId.thikaRoad,
    SceneId.jungle,
    SceneId.dirtRoad,
  };

  static const Map<SceneId, int> _twoLaps = {
    SceneId.city: 2,
    SceneId.suburbs: 2,
  };
  static const Map<SceneId, int> _threeLaps = {
    SceneId.city: 3,
    SceneId.suburbs: 3,
  };
  static const Map<SceneId, int> _fourLaps = {
    SceneId.city: 4,
    SceneId.suburbs: 4,
  };

  /// Every level, from 1 to [top].
  static const List<LevelRules> all = [
    LevelRules(
      level: 1,
      scenes: _starter,
      laps: _twoLaps,
      rivals: 0,
      maxSpeedKmh: 150,
      winPrize: 0,
      traffic: TrafficDensity.none,
    ),
    LevelRules(
      level: 2,
      scenes: _starter,
      laps: _twoLaps,
      rivals: 1,
      maxSpeedKmh: 150,
      winPrize: 250,
      traffic: TrafficDensity.veryLight,
      trafficFine: 100,
    ),
    LevelRules(
      level: 3,
      scenes: _withThika,
      laps: _threeLaps,
      rivals: 2,
      maxSpeedKmh: 200,
      winPrize: 400,
      traffic: TrafficDensity.light,
      trafficFine: 100,
      hospitalBill: 1500,
    ),
    LevelRules(
      level: 4,
      scenes: _withThika,
      laps: _threeLaps,
      rivals: 3,
      maxSpeedKmh: 200,
      winPrize: 750,
      traffic: TrafficDensity.light,
      trafficFine: 100,
      shoving: true,
      hospitalBill: 1500,
    ),
    LevelRules(
      level: 5,
      scenes: _everything,
      laps: _fourLaps,
      rivals: 4,
      maxSpeedKmh: 200,
      winPrize: 1200,
      traffic: TrafficDensity.light,
      trafficFine: 100,
      shoving: true,
      hospitalBill: 3000,
      garageBill: 3000,
      policeFine: 2000,
    ),
    LevelRules(
      level: 6,
      scenes: _everything,
      laps: _fourLaps,
      rivals: 5,
      maxSpeedKmh: 240,
      winPrize: 2000,
      traffic: TrafficDensity.heavy,
      trafficFine: 100,
      shoving: true,
      hospitalBill: 3000,
      garageBill: 3000,
      policeFine: 2000,
      pedestrians: true,
    ),
    LevelRules(
      level: 7,
      scenes: _everything,
      laps: _fourLaps,
      rivals: 5,
      maxSpeedKmh: 240,
      winPrize: 3000,
      traffic: TrafficDensity.heavy,
      trafficFine: 100,
      shoving: true,
      hospitalBill: 3000,
      garageBill: 3000,
      policeFine: 2000,
      pedestrians: true,
    ),
  ];

  /// Returns the rules of a level; levels outside 1 to [top] are clamped.
  static LevelRules of(int level) => all[level.clamp(1, top).toInt() - 1];

  /// Returns the first level that opens [scene].
  static int unlockLevelOf(SceneId scene) =>
      all.firstWhere((rules) => rules.isOpen(scene)).level;

  /// True when [scene] can be raced at this level.
  bool isOpen(SceneId scene) => scenes.contains(scene);

  /// Returns the laps of [scene], given the scene's own lap count.
  int lapsFor(SceneId scene, int sceneLaps) => laps[scene] ?? sceneLaps;

  /// The next level, or null at the top.
  LevelRules? get next => level < top ? of(level + 1) : null;

  /// Scenes that this level opens for the first time.
  Set<SceneId> get newScenes =>
      level == 1 ? const {} : scenes.difference(of(level - 1).scenes);

  /// True when winning pays prize money.
  bool get paysPrize => winPrize > 0;

  /// True when a nasty crash ends the race in hospital.
  bool get hospital => hospitalBill > 0;

  /// True when police patrol the road.
  bool get police => policeFine > 0;

  /// Top speed as a share of the bike's absolute top speed of [absoluteKmh].
  double speedShare(double absoluteKmh) => maxSpeedKmh / absoluteKmh;
}
