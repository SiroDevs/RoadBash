// Project imports:
import '../track/road_section.dart';
import 'route_feature.dart';
import 'route_scenery.dart';

export 'route_feature.dart';
export 'route_scenery.dart';

const int segmentsPerShot = 18;

class RoutePiece {
  const RoutePiece(this.weight, {this.curve = 0, this.hill = 0, this.section});

  final double weight;
  final double curve;
  final double hill;
  final Section? section;
}

class RouteStretch {
  const RouteStretch(
    this.name,
    this.shots, {
    this.pieces = const [RoutePiece(1)],
    this.section = Section.plain,
    this.left = const [],
    this.right = const [],
    this.features = const [],
  });

  final String name;
  final int shots;
  final List<RoutePiece> pieces;
  final Section section;
  final List<SideScenery> left, right;
  final List<RouteFeature> features;

  int get length => shots * segmentsPerShot;
}
