import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'presets.dart';

const List<RouteStretch> bluePostToKenyatta = [
  RouteStretch(
    'after blue post',
    6,
    pieces: [RoutePiece(1, hill: 1)],
    section: cutting,
    left: [
      SideScenery(
        to: 0.25,
        walls: [WallRun(WallStyle.rock, 0, 0.25, offset: 1.18)],
        treeStep: (6, 10),
        treeSetBack: (1.8, 3.0),
      ),
      SideScenery(
        from: 0.25,
        lots: 0.35,
        storeys: (1, 3),
        setBack: (2.4, 3.4),
        walls: [WallRun(WallStyle.block, 0.25, 1, offset: 1.3)],
        treeStep: (6, 11),
        treeSetBack: (1.8, 3.2),
      ),
    ],
    right: [SideScenery(treeStep: (5, 10), treeSetBack: farRightTrees)],
    features: [RouteFeature.gantry(0.72), RouteFeature.exitSign(0.9)],
  ),
  RouteStretch(
    'thika bypass',
    7,
    section: planted,
    left: [
      SideScenery(to: 0.5, treeStep: (3, 6), mix: TreeMix.belt, treeSetBack: (1.6, 2.6)),
      SideScenery(from: 0.5, treeStep: (8, 14), mix: bushy),
    ],
    right: [SideScenery(treeStep: (6, 12), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.exitSign(0.25),
      RouteFeature.exit(0.33),
      RouteFeature.billboard(0.45),
      RouteFeature.overpass(0.8),
    ],
  ),
  RouteStretch(
    'jomoko',
    4,
    pieces: [RoutePiece(1, hill: -1)],
    section: planted,
    left: [SideScenery(treeStep: (10, 18), mix: TreeMix.savanna)],
    right: [
      SideScenery(treeStep: (10, 18), mix: TreeMix.savanna, treeSetBack: farRightTrees),
      SideScenery(from: 0.55, lots: 0.4, storeys: (1, 2), setBack: farRight),
    ],
    features: [
      RouteFeature.billboard(0.1, side: -1, face: 1),
      RouteFeature.footbridge(0.4),
      RouteFeature.gantry(0.7),
      RouteFeature.exit(0.86, length: 26),
    ],
  ),
  RouteStretch(
    'tibs',
    3,
    section: planted,
    left: [
      SideScenery(lots: 0.9, storeys: (3, 4), setBack: serviceSide, service: true),
    ],
    right: [SideScenery(treeStep: (14, 22), mix: TreeMix.savanna, treeSetBack: farRightTrees)],
    features: [
      RouteFeature.billboard(0.15, face: 2),
      RouteFeature.building(0.4, storeys: 1, width: 3600, depth: 10, tint: 3),
      RouteFeature.billboard(0.75, face: 3),
    ],
  ),
  RouteStretch(
    'thika rd (bypass to witethie)',
    8,
    pieces: [RoutePiece(0.5, curve: 0.8, hill: 1), RoutePiece(0.5)],
    section: planted,
    left: [
      SideScenery(to: 0.2, lots: 0.8, storeys: (1, 2), setBack: serviceSide, service: true),
      SideScenery(from: 0.2, to: 0.85, treeStep: (14, 26), mix: TreeMix.savanna),
      SideScenery(from: 0.85, treeStep: (5, 9), mix: bushy),
    ],
    right: [SideScenery(treeStep: (14, 26), mix: TreeMix.savanna, treeSetBack: farRightTrees)],
    features: [
      RouteFeature.billboard(0.25, face: 1),
      RouteFeature.footbridge(0.5),
      RouteFeature.billboard(0.78, side: -1, face: 0),
    ],
  ),
  RouteStretch(
    'witethie',
    7,
    pieces: [RoutePiece(1, hill: 2)],
    section: cutting,
    left: [
      SideScenery(
        to: 0.4,
        lots: 0.9,
        storeys: (4, 5),
        setBack: (1.7, 2.3),
        walls: [WallRun(WallStyle.rock, 0, 0.4, offset: 1.18)],
      ),
      SideScenery(from: 0.4, to: 0.78, lots: 0.9, storeys: (2, 4), setBack: serviceSide, service: true),
      SideScenery(from: 0.78, treeStep: (6, 10), mix: bushy),
    ],
    right: [SideScenery(treeStep: (10, 20), mix: TreeMix.savanna, treeSetBack: farRightTrees)],
    features: [
      RouteFeature.footbridge(0.28),
      RouteFeature.footbridge(0.55, style: 2),
      RouteFeature.billboard(0.62, side: -1, face: 2),
    ],
  ),
  RouteStretch(
    'thika rd (witethie to juja)',
    11,
    pieces: [RoutePiece(0.5, curve: -0.8), RoutePiece(0.5)],
    section: planted,
    left: [SideScenery(treeStep: (5, 10), treeSetBack: (1.8, 3.4), mix: bushy)],
    right: [SideScenery(treeStep: (7, 14), treeSetBack: farRightTrees)],
    features: [RouteFeature.footbridge(0.02), RouteFeature.exitSign(0.92)],
  ),
  RouteStretch(
    'juja',
    11,
    pieces: [RoutePiece(1, hill: 1)],
    section: planted,
    left: [
      SideScenery(to: 0.55, lots: 0.92, storeys: (3, 5), setBack: serviceSide, service: true),
      SideScenery(from: 0.55, to: 0.8, lots: 0.7, storeys: (2, 4), setBack: serviceSide, service: true),
      SideScenery(
        from: 0.8,
        treeStep: (8, 12),
        walls: [WallRun(WallStyle.rock, 0.85, 1, offset: 1.18)],
      ),
    ],
    right: [
      SideScenery(lots: 0.4, storeys: (2, 5), setBack: farRight, treeStep: (8, 14), treeSetBack: farRightTrees),
      SideScenery(from: 0.85, lots: 0.8, storeys: (5, 9), setBack: (4.0, 5.0)),
    ],
    features: [
      RouteFeature.billboard(0.3),
      RouteFeature.footbridge(0.62),
      RouteFeature.overpass(0.9, style: 1),
    ],
  ),
  RouteStretch(
    'thika rd (kenyatta junction)',
    6,
    pieces: [RoutePiece(1, curve: 1.0)],
    section: cutting,
    left: [
      SideScenery(to: 0.35, treeStep: (4, 7), treeSetBack: (1.8, 3.0)),
      SideScenery(
        from: 0.35,
        to: 0.6,
        walls: [WallRun(WallStyle.rock, 0.4, 0.6, offset: 1.2)],
        treeStep: (6, 9),
      ),
      SideScenery(from: 0.6, lots: 0.8, storeys: (3, 5), setBack: serviceSide, service: true),
    ],
    right: [SideScenery(lots: 0.35, storeys: (1, 3), setBack: farRight)],
    features: [
      RouteFeature.entry(0.08),
      RouteFeature.footbridge(0.94),
    ],
  ),
];
