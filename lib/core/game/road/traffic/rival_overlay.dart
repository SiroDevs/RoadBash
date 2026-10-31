// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../road_renderer.dart';

/// Paints the rivals that are closer to the camera than the player's rider.
class RivalOverlay extends Component {
  RivalOverlay(this.road) : super(priority: 2);

  final RoadRenderer road;

  @override
  void render(Canvas canvas) => road.traffic?.paintBehind(canvas);
}
