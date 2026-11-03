// Project imports:
import '../../look/rider_look.dart';
import '../../view/placeholder_bike_painter.dart';
import '../../view/rider_view.dart';

/// The bike seen from the front. Starts as the schematic bike; override its
/// layers to draw the real front view piece by piece.
class FrontBikePainter extends PlaceholderBikePainter {
  FrontBikePainter(RiderLook look) : super(look, RiderView.front);
}
