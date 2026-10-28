import '../../props/sign_panel.dart';
import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'exits.dart';
import 'presets.dart';
import 'signage.dart';

const List<RouteStretch> bluePostToKroad = [
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
    features: [
      RouteFeature.gantry(0.72, panels: exit17Panels, boards: pelicanBoards),
      RouteFeature.exitSignNamed(0.9, exitThika),
    ],
  ),
  RouteStretch(
    'thika bypass',
    7,
    section: planted,
    left: [
      SideScenery(
        to: 0.5,
        treeStep: (3, 6),
        mix: TreeMix.belt,
        treeSetBack: (1.6, 2.6),
      ),
      SideScenery(from: 0.5, treeStep: (8, 14), mix: bushy),
    ],
    right: [SideScenery(treeStep: (6, 12), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.exit(0.22),
      RouteFeature.exitSignNumbered(0.35, SignPanel.numbered('17')),
      RouteFeature.billboard(0.45),
      RouteFeature.overpass(0.8),
    ],
  ),
  RouteStretch(
    'jomoko',
    5,
    pieces: [RoutePiece(1, hill: -1)],
    section: planted,
    left: [SideScenery(treeStep: (10, 18), mix: TreeMix.savanna)],
    right: [
      SideScenery(
        treeStep: (10, 18),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
      SideScenery(from: 0.55, lots: 0.4, storeys: (1, 2), setBack: farRight),
    ],
    features: [
      RouteFeature.exit(0.1, length: 26),
      RouteFeature.billboard(0.4, side: -1, face: 1),
      RouteFeature.footbridge(0.7),
    ],
  ),
  RouteStretch(
    'tibs',
    6,
    section: planted,
    left: [
      SideScenery(
        lots: 0.9,
        storeys: (3, 4),
        setBack: serviceSide,
        service: true,
      ),
    ],
    right: [
      SideScenery(
        treeStep: (14, 22),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.billboard(0.15, face: 2),
      RouteFeature.building(0.4, storeys: 1, width: 3600, depth: 10, tint: 3),
      RouteFeature.billboard(0.75, face: 3),
    ],
  ),
  RouteStretch(
    'thika to witethie)',
    8,
    pieces: [RoutePiece(0.5, curve: 0.8, hill: 1), RoutePiece(0.5)],
    section: planted,
    left: [
      SideScenery(
        to: 0.2,
        lots: 0.8,
        storeys: (1, 2),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(
        from: 0.2,
        to: 0.65,
        treeStep: (14, 26),
        mix: TreeMix.savanna,
      ),
      SideScenery(from: 0.65, treeStep: (5, 9), mix: bushy),
    ],
    right: [
      SideScenery(
        treeStep: (14, 26),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.billboard(0.35, face: 1),
      RouteFeature.footbridge(0.6),
      RouteFeature.billboard(0.9, side: -1, face: 0),
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
        walls: [WallRun(WallStyle.rock, 0, 0.4, offset: 2.38)],
      ),
      SideScenery(
        from: 0.4,
        to: 0.68,
        lots: 0.9,
        storeys: (2, 4),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(from: 0.78, treeStep: (6, 10), mix: bushy),
    ],
    right: [
      SideScenery(
        treeStep: (10, 20),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.exitSignNumbered(0.15, SignPanel.numbered('16')),
      RouteFeature.exit(0.22),
      RouteFeature.footbridge(0.48, style: 2),
      RouteFeature.billboard(0.62, side: -1, face: 2),
    ],
  ),
  RouteStretch(
    'witethie to juja',
    15,
    pieces: [RoutePiece(0.5, curve: -0.8), RoutePiece(0.5)],
    section: planted,
    left: [SideScenery(treeStep: (5, 10), treeSetBack: (1.8, 3.4), mix: bushy)],
    right: [SideScenery(treeStep: (7, 14), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.exitSignNamed(0.5, exitJuja, side: 1),
      RouteFeature.exit(0.85),
      RouteFeature.exitSignNumbered(0.9, SignPanel.numbered('15')),
      RouteFeature.footbridge(1.5),
    ],
  ),
  RouteStretch(
    'juja',
    12,
    pieces: [RoutePiece(1, hill: 1)],
    section: planted,
    left: [
      SideScenery(
        to: 0.55,
        lots: 0.92,
        storeys: (3, 5),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(
        from: 0.55,
        to: 0.8,
        lots: 0.7,
        storeys: (2, 4),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(
        from: 0.8,
        treeStep: (8, 12),
        walls: [WallRun(WallStyle.rock, 0.85, 1, offset: 1.18)],
      ),
    ],
    right: [
      SideScenery(
        lots: 0.4,
        storeys: (2, 5),
        setBack: farRight,
        treeStep: (8, 14),
        treeSetBack: farRightTrees,
      ),
      SideScenery(from: 0.85, lots: 0.8, storeys: (5, 9), setBack: (4.0, 5.0)),
    ],
    features: [
      RouteFeature.billboard(0.3),
      RouteFeature.footbridge(0.62),
      RouteFeature.overpass(1.5, style: 1),
    ],
  ),
  RouteStretch(
    'k-road',
    12,
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
      SideScenery(
        from: 0.6,
        lots: 0.8,
        storeys: (3, 5),
        setBack: serviceSide,
        service: true,
      ),
    ],
    right: [SideScenery(lots: 0.35, storeys: (1, 3), setBack: farRight)],
    features: [RouteFeature.entry(0.5), RouteFeature.footbridge(1.8)],
  ),
];