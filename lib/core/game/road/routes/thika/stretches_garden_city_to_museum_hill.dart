import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'presets.dart';

const List<RouteStretch> gardenCityToMuseumHill = [
  RouteStretch(
    'garden city',
    8,
    pieces: [RoutePiece(0.35, hill: -4, curve: 1.2), RoutePiece(0.65)],
    section: cutting,
    left: [
      SideScenery(to: 0.5, treeStep: (6, 10)),
      SideScenery(from: 0.5, to: 0.8, lots: 0.9, storeys: (1, 3), setBack: serviceSide, service: true),
      SideScenery(
        from: 0.8,
        walls: [WallRun(WallStyle.rock, 0.8, 1, offset: 1.2)],
      ),
    ],
    right: [
      SideScenery(lots: 0.6, storeys: (2, 5), setBack: farRight),
      SideScenery(from: 0.8, walls: [WallRun(WallStyle.rock, 0.8, 1, offset: 3.8)]),
    ],
    features: [
      RouteFeature.footbridge(0.5, style: 2),
      RouteFeature.gantry(0.62),
      RouteFeature.overpass(0.97),
    ],
  ),
  RouteStretch(
    'alsops',
    8,
    section: cutting,
    left: [
      SideScenery(
        lots: 0.5,
        storeys: (5, 6),
        setBack: (1.8, 2.4),
        walls: [WallRun(WallStyle.rock, 0, 0.9, offset: 1.2)],
      ),
    ],
    right: [SideScenery(walls: [WallRun(WallStyle.rock, 0, 0.9, offset: 3.8)])],
    features: [
      RouteFeature.exitSign(0.02),
      RouteFeature.gantry(0.1),
      RouteFeature.overpass(0.4),
      RouteFeature.footbridge(0.6, style: 3),
      RouteFeature.overpass(0.75, style: 1),
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
    right: [SideScenery(to: 0.4, treeStep: (3, 6), treeSetBack: farRightTrees), SideScenery(from: 0.4, treeStep: (6, 10), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.footbridge(0.3),
      RouteFeature.gantry(0.62),
      RouteFeature.building(0.88, side: -1, storeys: 8, depth: 10, width: 3000, setBack: 2.2, tint: 5),
    ],
  ),
  RouteStretch(
    'survey',
    6,
    pieces: [RoutePiece(0.6, curve: 1.6, hill: 1), RoutePiece(0.4)],
    section: planted,
    left: [SideScenery(treeStep: (4, 8), mix: TreeMix.belt, treeSetBack: (1.8, 3.2))],
    right: [SideScenery(treeStep: (4, 8), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.footbridge(0.45, style: 1),
      RouteFeature.billboard(0.62, face: 4),
    ],
  ),
  RouteStretch(
    'muthaiga',
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
      SideScenery(from: 0.65, to: 0.9, lots: 0.7, storeys: (9, 12), setBack: (2.2, 3.0)),
    ],
    right: [
      SideScenery(treeStep: (5, 9), treeSetBack: farRightTrees),
      SideScenery(from: 0.9, walls: [WallRun(WallStyle.concrete, 0.9, 1, offset: 3.8)]),
    ],
    features: [
      RouteFeature.billboard(0.3, face: 1),
      RouteFeature.gantry(0.48),
      RouteFeature.billboard(0.5, face: 2),
      RouteFeature.footbridge(0.56, style: 1),
      RouteFeature.billboard(0.7, face: 3),
      RouteFeature.billboard(0.85, face: 0),
      RouteFeature.overpass(0.9, style: 1),
    ],
  ),
  RouteStretch(
    'pangani',
    9,
    pieces: [
      RoutePiece(0.25),
      RoutePiece(0.2, hill: -6, section: trench),
      RoutePiece(0.3, section: trench),
      RoutePiece(0.25, hill: 6, section: trench),
    ],
    section: cutting,
    left: [
      SideScenery(to: 0.3, lots: 0.9, storeys: (2, 5), setBack: serviceSide, service: true),
      SideScenery(
        from: 0.38,
        lots: 0.5,
        storeys: (4, 6),
        setBack: (1.5, 2.0),
        walls: [WallRun(WallStyle.concrete, 0.38, 1, offset: 1.12)],
      ),
    ],
    right: [
      SideScenery(to: 0.3, lots: 0.7, storeys: (3, 6), setBack: farRight),
      SideScenery(from: 0.38, walls: [WallRun(WallStyle.concrete, 0.38, 1, offset: 1.12)]),
    ],
    features: [
      RouteFeature.footbridge(0.03, style: 1),
      RouteFeature.billboard(0.15, face: 1),
      RouteFeature.tunnel(0.62, 36),
    ],
  ),
  RouteStretch(
    'forest rd',
    6,
    section: urban,
    left: [
      SideScenery(
        to: 0.2,
        lots: 0.6,
        storeys: (4, 6),
        setBack: (1.5, 2.0),
        walls: [WallRun(WallStyle.concrete, 0, 0.2, offset: 1.12)],
      ),
      SideScenery(from: 0.2, to: 0.7, lots: 0.85, storeys: (4, 6), setBack: (2.0, 2.6), walls: [WallRun(WallStyle.block, 0.2, 0.7, offset: 1.4)]),
      SideScenery(from: 0.7, treeStep: (3, 6), treeSetBack: (1.8, 3.0)),
    ],
    right: [
      SideScenery(to: 0.2, walls: [WallRun(WallStyle.concrete, 0, 0.2, offset: 1.12)]),
      SideScenery(from: 0.2, to: 0.55, lots: 0.8, storeys: (5, 7), setBack: (3.9, 4.5)),
      SideScenery(from: 0.55, treeStep: (3, 6), treeSetBack: farRightTrees),
    ],
    features: [RouteFeature.gantry(0.3), RouteFeature.gantry(0.62)],
  ),
  RouteStretch(
    'parklands',
    8,
    pieces: [RoutePiece(0.5, curve: 1.0), RoutePiece(0.5, curve: -1.2)],
    section: urban,
    left: [
      SideScenery(
        to: 0.7,
        lots: 0.8,
        storeys: (3, 6),
        setBack: serviceSide,
        service: true,
        treeStep: (6, 10),
      ),
      SideScenery(
        from: 0.7,
        treeStep: (3, 6),
        walls: [
          WallRun(WallStyle.hoarding, 0.7, 0.85, offset: 1.4),
          WallRun(WallStyle.block, 0.85, 1, offset: 1.4),
        ],
      ),
    ],
    right: [SideScenery(lots: 0.7, storeys: (3, 7), setBack: farRight, treeStep: (5, 9), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.entry(0.25),
      RouteFeature.overpass(0.4),
      RouteFeature.exit(0.55),
      RouteFeature.billboard(0.3, side: -1, face: 2),
    ],
  ),
  RouteStretch(
    'museum hill',
    2,
    pieces: [RoutePiece(1, hill: 3, curve: 1.4)],
    section: urban,
    left: [SideScenery(to: 0.5, lots: 0.9, storeys: (4, 6), setBack: serviceSide)],
    right: [SideScenery(treeStep: (5, 8), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.exit(0.1),
      RouteFeature.gantry(0.7),
      RouteFeature.building(0.85, storeys: 14, depth: 10, width: 3200, setBack: 4.0, tint: 3),
    ],
  ),
];
