import '../../props/sign_panel.dart';
import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'exits.dart';
import 'presets.dart';
import 'signage.dart';

const List<RouteStretch> kRoadToRuiru = [
  RouteStretch(
    'Kroad',
    5,
    section: planted,
    left: [
      SideScenery(
        to: 0.7,
        lots: 0.5,
        storeys: (1, 2),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(from: 0.7, treeStep: (12, 20), mix: TreeMix.savanna),
    ],
    right: [
      SideScenery(to: 0.4, lots: 0.85, storeys: (5, 6), setBack: (3.9, 4.6)),
      SideScenery(
        from: 0.45,
        to: 0.75,
        treeStep: (4, 7),
        treeSetBack: farRightTrees,
      ),
      SideScenery(
        from: 0.75,
        treeStep: (14, 22),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.exitSignNamed(0.2, exitKroad),
      RouteFeature.exitSignNumbered(0.5, SignPanel.numbered('14')),
      RouteFeature.exit(0.7),
      RouteFeature.overpass(1.2),
    ],
  ),
  RouteStretch(
    'toll',
    10,
    pieces: [RoutePiece(0.5, curve: 1.2, hill: -1), RoutePiece(0.5)],
    section: bridged,
    left: [
      SideScenery(
        to: 0.5,
        treeStep: (6, 10),
        mix: TreeMix.savanna,
        walls: [
          WallRun(WallStyle.parapet, 0.1, 0.28, offset: 1.16),
          WallRun(WallStyle.block, 0.35, 0.5, offset: 1.5),
        ],
      ),
      SideScenery(
        from: 0.5,
        lots: 0.5,
        storeys: (1, 3),
        setBack: nearLeft,
        treeStep: (6, 10),
      ),
    ],
    right: [
      SideScenery(treeStep: (6, 12), mix: bushy, treeSetBack: farRightTrees),
    ],
    features: [
      RouteFeature.gantry(1.8, panels: exit16Panels, boards: pelicanBoards),
      RouteFeature.building(3.5, storeys: 4, depth: 12, width: 3400, tint: 2),
      RouteFeature.building(4.2, storeys: 2, depth: 10, width: 3000, tint: 0),
    ],
  ),
  RouteStretch(
    'kimbo',
    6,
    pieces: [RoutePiece(0.3, hill: 4), RoutePiece(0.7)],
    section: elevated,
    left: [
      SideScenery(
        lots: 0.9,
        storeys: (2, 4),
        setBack: (1.5, 2.2),
        drop: 1000,
        walls: [WallRun(WallStyle.parapet, 0.15, 1, offset: 1.16)],
      ),
    ],
    right: [
      SideScenery(lots: 0.5, storeys: (2, 5), setBack: (4.2, 5.0), drop: 700),
    ],
    features: [
      RouteFeature.building(
        1,
        side: -1,
        storeys: 2,
        depth: 10,
        width: 3200,
        setBack: 1.8,
        tint: 3,
      ),
    ],
  ),
  RouteStretch(
    'kwa kairu',
    9,
    pieces: [RoutePiece(0.5, curve: -0.8), RoutePiece(0.5)],
    section: elevated,
    left: [
      SideScenery(
        to: 0.45,
        lots: 1,
        storeys: (2, 4),
        setBack: (1.5, 2.2),
        drop: 900,
        walls: [WallRun(WallStyle.parapet, 0, 0.45, offset: 1.16)],
      ),
      SideScenery(
        from: 0.45,
        to: 1,
        treeStep: (4, 7),
        treeSetBack: (1.8, 3.0),
      ),
      SideScenery(
        from: 1,
        lots: 2,
        storeys: (1, 3),
        setBack: (1.7, 2.4),
        drop: 400,
      ),
    ],
    right: [
      SideScenery(
        from: 1.2,
        to: 2.5,
        lots: 0.7,
        storeys: (2, 4),
        setBack: farRight,
      ),
      SideScenery(
        from: 1.2,
        to: 2.5,
        treeStep: (4, 8),
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.building(
        1,
        storeys: 4,
        depth: 18,
        width: 5200,
        setBack: 4.0,
        tint: 2,
      ),
      RouteFeature.overpass(3),
      RouteFeature.footbridge(4.5),
    ],
  ),
];
