// Project imports:
import '../look/rider_look.dart';
import '../view/bike_view_painter.dart';
import '../view/rider_view.dart';
import 'front/front_bike_painter.dart';
import 'left/left_bike_painter.dart';
import 'rear/rear_bike_painter.dart';
import 'right/right_bike_painter.dart';

/// Returns the painter that draws the bike of [look] as seen from [view].
BikeViewPainter bikePainterFor(RiderView view, RiderLook look) => switch (view) {
  RiderView.rear => RearBikePainter(look),
  RiderView.front => FrontBikePainter(look),
  RiderView.left => LeftBikePainter(look),
  RiderView.right => RightBikePainter(look),
};
