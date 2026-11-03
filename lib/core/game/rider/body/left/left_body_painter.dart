// Project imports:
import '../../look/rider_look.dart';
import '../../view/placeholder_body_painter.dart';
import '../../view/rider_view.dart';

/// The rider seen from the left. Starts as the schematic rider; replace its
/// `paint` with the real left view, using the bike's anchors for the hands,
/// feet and hips.
class LeftBodyPainter extends PlaceholderBodyPainter {
  LeftBodyPainter(RiderLook look) : super(look, RiderView.left);
}
