// Project imports:
import '../../props/sign_panel.dart';
import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'exits.dart';
import 'presets.dart';
import 'signage.dart';
import 'signage2.dart';

const List<RouteStretch> gardenCityToPangani = [
  RouteStretch(
    'garden city',
    12,
    pieces: [RoutePiece(0.35, hill: -4, curve: 1.2), RoutePiece(0.65)],
    section: cutting,
    left: [
      SideScenery(to: 0.5, treeStep: (6, 10)),
      SideScenery(
        from: 0.3,
        to: 0.7,
        lots: 0.9,
        storeys: (1, 3),
        setBack: serviceSide,
        service: true,
      ),
      SideScenery(
        from: 0.7,
        walls: [WallRun(WallStyle.rock, 0.6, 1.1, offset: 1.2)],
      ),
    ],
    right: [
      SideScenery(lots: 0.6, storeys: (2, 5), setBack: farRight),
      SideScenery(
        from: 0.8,
        walls: [WallRun(WallStyle.rock, 0.8, 1, offset: 3.8)],
      ),
    ],
    features: [
      RouteFeature.footbridge(0.25, style: 2),
      RouteFeature.gantry(0.45, panels: exit7Panels, boards: pelicanBoards),
      RouteFeature.exitSignNumbered(0.52, SignPanel.numbered('7')),
      RouteFeature.exit(0.58),
      RouteFeature.overpass(1),
    ],
  ),
  RouteStretch(
    'alsops',
    10,
    section: cutting,
    left: [SideScenery(lots: 0.5, setBack: (1.8, 2.4))],
    right: [
      SideScenery(walls: [WallRun(WallStyle.rock, 0, 0.9, offset: 3.8)]),
    ],
    features: [
      RouteFeature.exitSignNumbered(0.5, SignPanel.numbered('6')),
      RouteFeature.exit(0.7),
      RouteFeature.gantry(0.8, panels: exit6Panels, boards: pelicanBoards1),
      RouteFeature.overpass(1.2),
      RouteFeature.footbridge(2.5, style: 3),
    ],
  ),
  RouteStretch(
    'drive in',
    6,
    pieces: [RoutePiece(0.4, hill: 4), RoutePiece(0.6, curve: -1.2)],
    section: elevated,
    left: [
      SideScenery(
        to: 0.7,
        lots: 0.4,
        storeys: (1, 2),
        setBack: serviceSide,
        walls: [WallRun(WallStyle.white, 0.4, 0.7, offset: 1.5)],
      ),
      SideScenery(from: 0.7, treeStep: (4, 7)),
    ],
    right: [
      SideScenery(to: 0.4, treeStep: (3, 6), treeSetBack: farRightTrees),
      SideScenery(from: 0.4, treeStep: (6, 10), treeSetBack: farRightTrees),
    ],
    features: [
      RouteFeature.footbridge(0.5, style: 2),
      RouteFeature.gantry(1.5, panels: exit5Panels, boards: pelicanBoards2),
      RouteFeature.building(
        2.2,
        side: -1,
        storeys: 8,
        depth: 10,
        width: 3000,
        setBack: 2.2,
        tint: 5,
      ),
    ],
  ),
  RouteStretch(
    'survey',
    6,
    pieces: [RoutePiece(0.6, curve: 1.6, hill: 1), RoutePiece(0.4)],
    section: planted,
    left: [
      SideScenery(treeStep: (4, 8), mix: TreeMix.belt, treeSetBack: (1.8, 3.2)),
    ],
    right: [SideScenery(treeStep: (4, 8), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.footbridge(0.45, style: 1),
      RouteFeature.billboard(0.75, face: 4),
    ],
  ),
  RouteStretch(
    'mathare',
    8,
    pieces: [RoutePiece(0.6, curve: -1.4), RoutePiece(0.4)],
    section: cutting,
    left: [
      SideScenery(
        to: 0.45,
        treeStep: (4, 8),
        mix: TreeMix.belt,
        walls: [WallRun(WallStyle.white, 0, 0.45, offset: 1.3)],
      ),
      SideScenery(
        from: 0.65,
        to: 0.9,
        lots: 0.7,
        storeys: (9, 12),
        setBack: (2.2, 3.0),
      ),
    ],
    right: [
      SideScenery(treeStep: (5, 9), treeSetBack: farRightTrees),
      SideScenery(
        from: 0.9,
        walls: [WallRun(WallStyle.concrete, 0.9, 1, offset: 3.8)],
      ),
    ],
    features: [
      RouteFeature.billboard(0.3, face: 1),
      RouteFeature.gantry(1, panels: exit4Panels),
      RouteFeature.billboard(1.5, face: 2),
      RouteFeature.footbridge(1.8, style: 1),
      RouteFeature.billboard(2, face: 3),
      RouteFeature.billboard(2.4, face: 0),
      RouteFeature.overpass(2.9, style: 1),
    ],
  ),
];
