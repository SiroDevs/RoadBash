// Project imports:
import '../scene_theme.dart';
import 'road_track.dart';

/// True when a segment lies on the far right of a dual carriageway.
bool isFarRight(RoadTrack track, SceneTheme theme, int index) =>
    theme.dualCarriageway && track.segments[index].section.hasOpposite;
