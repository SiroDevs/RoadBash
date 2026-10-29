// Project imports:
import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'presets.dart';
import 'signage.dart';
import 'signage2.dart';

const List<RouteStretch> panganiToMuseum = [
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
      SideScenery(
        to: 0.3,
        lots: 0.9,
        storeys: (2, 5),
        setBack: serviceSide,
        service: true,
      ),
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
      SideScenery(
        from: 0.38,
        walls: [WallRun(WallStyle.concrete, 0.38, 1, offset: 1.12)],
      ),
    ],
    features: [
      RouteFeature.footbridge(0.2, style: 1),
      RouteFeature.billboard(0.3, face: 1),
      RouteFeature.gantry(0.8, panels: panganiPanels),
      RouteFeature.tunnel(1, 45),
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
      SideScenery(
        from: 0.2,
        to: 0.7,
        lots: 0.85,
        storeys: (4, 6),
        setBack: (2.0, 2.6),
        walls: [WallRun(WallStyle.block, 0.2, 0.7, offset: 1.4)],
      ),
      SideScenery(from: 0.7, treeStep: (3, 6), treeSetBack: (1.8, 3.0)),
    ],
    right: [
      SideScenery(
        to: 0.2,
        walls: [WallRun(WallStyle.concrete, 0, 0.2, offset: 1.12)],
      ),
      SideScenery(
        from: 0.2,
        to: 0.55,
        lots: 0.8,
        storeys: (5, 7),
        setBack: (3.9, 4.5),
      ),
      SideScenery(from: 0.55, treeStep: (3, 6), treeSetBack: farRightTrees),
    ],
    features: [
      RouteFeature.gantry(1.5, panels: exit2Panels),
    ],
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
    right: [
      SideScenery(
        lots: 0.7,
        storeys: (3, 7),
        setBack: farRight,
        treeStep: (5, 9),
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.entry(0.25),
      RouteFeature.exit(0.55),
      RouteFeature.billboard(0.3, side: -1, face: 2),
    ],
  ),
  RouteStretch(
    'museum hill',
    2,
    pieces: [RoutePiece(1, hill: 3, curve: 1.4)],
    section: urban,
    left: [
      SideScenery(to: 0.5, lots: 0.9, storeys: (4, 6), setBack: serviceSide),
    ],
    right: [SideScenery(treeStep: (5, 8), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.exit(0.3),
      RouteFeature.gantry(1, panels: exit7Panels),
      RouteFeature.building(
        1.85,
        storeys: 14,
        depth: 10,
        width: 3200,
        setBack: 4.0,
        tint: 3,
      ),
    ],
  ),
];
