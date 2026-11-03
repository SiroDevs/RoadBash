// Project imports:
import '../../look/rider_look.dart';
import '../../view/placeholder_bike_painter.dart';
import '../../view/rider_view.dart';

/// The bike seen from the left. Starts as the schematic bike; override its
/// layers to draw the real left view piece by piece.
class LeftBikePainter extends PlaceholderBikePainter {
  LeftBikePainter(RiderLook look) : super(look, RiderView.left);
}
