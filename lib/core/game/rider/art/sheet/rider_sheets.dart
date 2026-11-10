// Project imports:
import 'art_shape.dart';
import 'data/rider_front_data.dart';
import 'data/rider_rear_data.dart';
import 'data/rider_running_data.dart';
import 'data/rider_sideways_data.dart';
import 'data/rider_standing_data.dart';

/// The packed rider artwork views, built once on first use.
class RiderSheets {
  static final ArtSheet rear = ArtSheet(riderRearParts, riderRearAnchors);
  static final ArtSheet front = ArtSheet(riderFrontParts, riderFrontAnchors);
  static final ArtSheet standing = ArtSheet(
    riderStandingParts,
    riderStandingAnchors,
  );
  static final ArtSheet running = ArtSheet(
    riderRunningParts,
    riderRunningAnchors,
  );
  static final ArtSheet sideways = ArtSheet(
    riderSidewaysParts,
    riderSidewaysAnchors,
  );
}
