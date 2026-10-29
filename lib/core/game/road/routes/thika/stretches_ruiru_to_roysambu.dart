// Project imports:
import '../../props/sign_panel.dart';
import '../../props/wall_style.dart';
import '../route_stretch.dart';
import 'exits.dart';
import 'presets.dart';
import 'signage.dart';

const List<RouteStretch> ruiruToRoysambu = [
  RouteStretch(
    'ruiru',
    9,
    pieces: [RoutePiece(0.55, curve: 1.0), RoutePiece(0.45, curve: -0.6)],
    section: elevated,
    left: [
      SideScenery(
        to: 0.45,
        lots: 0.85,
        storeys: (4, 7),
        setBack: (2.0, 2.6),
        drop: 500,
      ),
      SideScenery(
        from: 0.55,
        treeStep: (14, 24),
        mix: TreeMix.savanna,
        walls: [WallRun(WallStyle.parapet, 0.15, 0.35, offset: 1.16)],
      ),
    ],
    right: [
      SideScenery(
        from: 0.1,
        to: 0.4,
        lots: 0.8,
        storeys: (4, 6),
        setBack: farRight,
      ),
      SideScenery(
        from: 0.6,
        treeStep: (14, 24),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.gantry(0.1, panels: exit11Panels, boards: pelicanBoards),
      RouteFeature.exitSignNamed(0.3, exitRuiru),
      RouteFeature.exitSignNumbered(0.42, SignPanel.numbered('11')),
      RouteFeature.exit(0.5),
      RouteFeature.overpass(0.8),
    ],
  ),
  RouteStretch(
    'ruiru to ku',
    8,
    pieces: [RoutePiece(0.3, hill: -4), RoutePiece(0.7)],
    section: planted,
    left: [
      SideScenery(
        to: 0.8,
        treeStep: (2, 4),
        mix: TreeMix.belt,
        treeSetBack: (2.0, 3.0),
      ),
      SideScenery(from: 0.8, treeStep: (10, 18), mix: TreeMix.savanna),
    ],
    right: [
      SideScenery(
        treeStep: (14, 24),
        mix: TreeMix.savanna,
        treeSetBack: farRightTrees,
      ),
    ],
    features: [
      RouteFeature.building(
        0.3,
        side: -1,
        storeys: 1,
        depth: 6,
        width: 1800,
        setBack: 1.7,
        tint: 5,
      ),
      RouteFeature.building(
        0.55,
        side: -1,
        storeys: 1,
        depth: 6,
        width: 1800,
        setBack: 1.7,
        tint: 5,
      ),
      RouteFeature.billboard(0.5, face: 3),
      RouteFeature.billboard(0.8, face: 0),
    ],
  ),
  RouteStretch(
    'ku',
    5,
    section: planted,
    left: [
      SideScenery(to: 0.5, treeStep: (4, 8), treeSetBack: (1.8, 3.0)),
      SideScenery(
        from: 0.5,
        to: 0.88,
        lots: 0.9,
        storeys: (6, 9),
        setBack: (3.0, 3.6),
        service: true,
      ),
      SideScenery(from: 0.88, treeStep: (5, 8)),
    ],
    right: [SideScenery(treeStep: (6, 10), treeSetBack: farRightTrees)],
    features: [
      RouteFeature.footbridge(0.3, style: 3),
      RouteFeature.footbridge(2, style: 1),
      RouteFeature.gantry(3.5, panels: exit10Panels, boards: pelicanBoards),
    ],
  ),
  RouteStretch(
    'kahawa',
    9,
    pieces: [RoutePiece(0.3, hill: 4), RoutePiece(0.7)],
    section: elevated,
    left: [
      SideScenery(
        lots: 0.9,
        storeys: (3, 5),
        setBack: (1.6, 2.2),
        drop: 800,
        walls: [WallRun(WallStyle.concrete, 0.1, 1, offset: 1.16)],
      ),
    ],
    right: [
      SideScenery(to: 0.3, treeStep: (6, 10), treeSetBack: farRightTrees),
      SideScenery(
        from: 0.3,
        lots: 0.6,
        storeys: (2, 4),
        setBack: farRight,
        drop: 500,
      ),
    ],
    features: [
      RouteFeature.footbridge(0.55, style: 3),
      RouteFeature.exitSignNamed(0.9, exitGithurai),
      RouteFeature.exitSign(1.2),
      RouteFeature.exit(1.5),
    ],
  ),
  RouteStretch(
    'githurai',
    10,
    pieces: [
      RoutePiece(0.7),
      RoutePiece(0.3, hill: -4, section: planted),
    ],
    section: elevated,
    left: [
      SideScenery(
        to: 0.75,
        lots: 0.95,
        storeys: (4, 6),
        setBack: (1.6, 2.2),
        drop: 900,
        walls: [WallRun(WallStyle.concrete, 0, 0.75, offset: 1.16)],
      ),
      SideScenery(from: 0.75, to: 0.9, treeStep: (6, 10)),
      SideScenery(from: 0.9, lots: 0.8, storeys: (4, 6), setBack: serviceSide),
    ],
    right: [
      SideScenery(lots: 0.6, storeys: (3, 6), setBack: farRight, drop: 400),
    ],
    features: [
      RouteFeature.gantry(1, panels: exit10Panels, boards: pelicanBoards),
    ],
  ),
  RouteStretch(
    'roysambu',
    15,
    pieces: [
      RoutePiece(0.1, hill: 4),
      RoutePiece(0.7, curve: -1.4),
      RoutePiece(0.2, hill: -3, section: planted),
    ],
    section: elevated,
    left: [
      SideScenery(
        to: 0.7,
        lots: 0.9,
        storeys: (3, 5),
        setBack: (1.6, 2.2),
        drop: 800,
        walls: [WallRun(WallStyle.parapet, 0.1, 0.7, offset: 1.16)],
      ),
      SideScenery(
        from: 0.7,
        lots: 0.6,
        storeys: (2, 4),
        setBack: serviceSide,
        treeStep: (6, 10),
      ),
    ],
    right: [
      SideScenery(lots: 0.6, storeys: (3, 8), setBack: farRight, drop: 500),
    ],
    features: [
      RouteFeature.footbridge(0.13),
      RouteFeature.gantry(3.5, panels: exit8Panels, boards: pelicanBoards),
      RouteFeature.footbridge(3.8, style: 1),
      RouteFeature.overpass(4.2),
    ],
  ),
];
