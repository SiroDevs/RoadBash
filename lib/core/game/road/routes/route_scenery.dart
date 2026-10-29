// Project imports:
import '../props/prop.dart';
import '../props/wall_style.dart';

/// Relative share of each tree kind in a scenery run.
class TreeMix {
  const TreeMix(this.acacia, this.pine, this.broadleaf, this.bush);

  final double acacia, pine, broadleaf, bush;

  /// Picks a tree kind from a 0-1 random roll.
  PropKind pick(double roll) {
    final total = acacia + pine + broadleaf + bush;
    final target = roll * total;
    if (target < acacia) return PropKind.acacia;
    if (target < acacia + pine) return PropKind.pine;
    if (target < acacia + pine + broadleaf) return PropKind.broadleaf;
    return PropKind.bush;
  }

  static const savanna = TreeMix(0.7, 0.05, 0.1, 0.15);
  static const belt = TreeMix(0, 0.85, 0.15, 0);
  static const leafy = TreeMix(0, 0.15, 0.7, 0.15);
  static const garden = TreeMix(0, 0.05, 0.75, 0.2);
}

/// A wall along part of a stretch.
class WallRun {
  const WallRun(this.style, this.from, this.to, {this.offset = 1.2});

  final WallStyle style;
  final double from, to, offset;
}

/// Scenery for one side of a stretch: buildings, trees and walls.
class SideScenery {
  const SideScenery({
    this.from = 0,
    this.to = 1,
    this.lots = 0,
    this.storeys = (2, 4),
    this.setBack = (2.2, 3.0),
    this.treeStep,
    this.treeSetBack = (2.0, 4.0),
    this.mix = TreeMix.leafy,
    this.walls = const [],
    this.service = false,
    this.drop = 0,
  });

  final double from, to;
  final double lots;
  final (int, int) storeys;
  final (double, double) setBack;
  final (int, int)? treeStep;
  final (double, double) treeSetBack;
  final TreeMix mix;
  final List<WallRun> walls;
  final bool service;
  final double drop;
}
