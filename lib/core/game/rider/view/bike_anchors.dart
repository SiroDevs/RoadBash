// Dart imports:
import 'dart:ui';

/// Where the rider attaches to the bike, in the drawing area of the view.
///
/// The bike painter works these out for its view and pose, and the rider
/// painter reaches for them: hands to the grips, feet to the pegs, hips to the
/// seat. That is what lets the bike and the rider be drawn separately.
class BikeAnchors {
  const BikeAnchors({
    required this.seat,
    required this.leftGrip,
    required this.rightGrip,
    required this.leftPeg,
    required this.rightPeg,
    required this.wheelContact,
  });

  final Offset seat;
  final Offset leftGrip;
  final Offset rightGrip;
  final Offset leftPeg;
  final Offset rightPeg;

  /// Where the wheels touch the ground.
  final Offset wheelContact;

  /// Returns the grip on a side: -1 for the rider's left, 1 for the right.
  Offset gripOf(int side) => side < 0 ? leftGrip : rightGrip;

  /// Returns the peg on a side: -1 for the rider's left, 1 for the right.
  Offset pegOf(int side) => side < 0 ? leftPeg : rightPeg;

  /// Returns the anchors moved by [dx] and [dy].
  BikeAnchors shifted(double dx, double dy) {
    final by = Offset(dx, dy);
    return BikeAnchors(
      seat: seat + by,
      leftGrip: leftGrip + by,
      rightGrip: rightGrip + by,
      leftPeg: leftPeg + by,
      rightPeg: rightPeg + by,
      wheelContact: wheelContact + by,
    );
  }
}
