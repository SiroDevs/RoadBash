// Project imports:
import '../look/rider_look.dart';
import '../view/body_view_painter.dart';
import '../view/rider_view.dart';
import 'front/front_body_painter.dart';
import 'left/left_body_painter.dart';
import 'rear/rear_body_painter.dart';
import 'right/right_body_painter.dart';

/// Returns the painter that draws the rider of [look] as seen from [view].
BodyViewPainter bodyPainterFor(RiderView view, RiderLook look) => switch (view) {
  RiderView.rear => RearBodyPainter(look),
  RiderView.front => FrontBodyPainter(look),
  RiderView.left => LeftBodyPainter(look),
  RiderView.right => RightBodyPainter(look),
};
