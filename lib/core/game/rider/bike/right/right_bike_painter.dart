// Project imports:
import '../../look/rider_look.dart';
import '../../view/placeholder_bike_painter.dart';
import '../../view/rider_view.dart';

/// The bike seen from the right. Starts as the schematic bike; override its
/// layers to draw the real right view piece by piece.
class RightBikePainter extends PlaceholderBikePainter {
  RightBikePainter(RiderLook look) : super(look, RiderView.right);
}
