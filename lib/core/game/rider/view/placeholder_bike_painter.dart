// Dart imports:
import 'dart:ui';

// Project imports:
import '../rider_pose.dart';
import 'bike_anchors.dart';
import 'bike_view_painter.dart';
import 'part_painter.dart';
import 'rider_view.dart';

/// A schematic bike for a view that has not been drawn yet: wheels, frame and
/// handlebar placed where the real drawing must put them. The front, left and
/// right bike painters start as this; override its layers to replace the
/// schematic with the real drawing one piece at a time.
class PlaceholderBikePainter extends RiderPartPainter implements BikeViewPainter {
  PlaceholderBikePainter(super.look, this.view);

  @override
  final RiderView view;

  static const double _wheelRadius = 28;
  static const double _wheelBase = 110;
  static const Color _tyre = Color(0xFF1A1A1A);

  @override
  void paintShadow(Canvas canvas, RiderPose pose) {
    final spec = view.canvas;
    oval(
      canvas,
      Rect.fromCenter(
        center: Offset(spec.midX + pose.lean * 23, spec.groundY + 4),
        width: view.isSide ? 150 : 96,
        height: 15,
      ),
      const Color(0x4D000000),
    );
  }

  @override
  void paintBehindRider(Paint paint, Path path, Canvas canvas, RiderPose pose) {
    if (view.isSide) return;
    final anchors = this.anchors(pose);
    limb(canvas, anchors.leftGrip, anchors.rightGrip, 5, bike.frame);
  }

  @override
  void paintInFrontOfRider(Paint paint, Path path, Canvas canvas, RiderPose pose) {
    final anchors = this.anchors(pose);
    if (view.isSide) {
      _sideFrame(canvas, anchors);
      return;
    }
    final spec = view.canvas;
    fill(canvas, Rect.fromCenter(center: Offset(spec.midX, anchors.seat.dy + 12), width: 36, height: 34), bike.panel, 8);
  }

  @override
  void paintOverRider(Paint paint, Path path, Canvas canvas, RiderPose pose) {
    final anchors = this.anchors(pose);
    final spec = view.canvas;
    if (view.isSide) {
      _sideWheels(canvas, anchors);
      return;
    }
    fill(canvas, Rect.fromLTWH(spec.midX - 6, spec.groundY - 70, 12, 70), _tyre, 5);
  }

  @override
  BikeAnchors anchors(RiderPose pose) {
    final spec = view.canvas;
    if (!view.isSide) {
      return BikeAnchors(
        seat: Offset(spec.midX, 96),
        leftGrip: handOf(-1, pose),
        rightGrip: handOf(1, pose),
        leftPeg: const Offset(30, 130),
        rightPeg: Offset(spec.width - 30, 130),
        wheelContact: Offset(spec.midX, spec.groundY),
      );
    }
    final left = BikeAnchors(
      seat: Offset(spec.midX - 12, 96),
      leftGrip: Offset(spec.midX + 32, 74 + tuckOf(pose)),
      rightGrip: Offset(spec.midX + 32, 74 + tuckOf(pose)),
      leftPeg: Offset(spec.midX - 4, 134),
      rightPeg: Offset(spec.midX - 4, 134),
      wheelContact: Offset(spec.midX, spec.groundY),
    );
    if (view == RiderView.left) return left;
    return BikeAnchors(
      seat: spec.mirror(left.seat),
      leftGrip: spec.mirror(left.leftGrip),
      rightGrip: spec.mirror(left.rightGrip),
      leftPeg: spec.mirror(left.leftPeg),
      rightPeg: spec.mirror(left.rightPeg),
      wheelContact: spec.mirror(left.wheelContact),
    );
  }

  /// Returns the direction the bike points along the ground: -1 for the left
  /// view, 1 for the right view.
  double get _heading => view == RiderView.right ? 1 : -1;

  /// Draws the side-on frame, tank and fork as straight lines.
  void _sideFrame(Canvas canvas, BikeAnchors anchors) {
    final ahead = -_heading;
    final contact = anchors.wheelContact;
    final rear = Offset(contact.dx - ahead * _wheelBase / 2, contact.dy - _wheelRadius);
    final front = Offset(contact.dx + ahead * _wheelBase / 2, contact.dy - _wheelRadius);
    final head = Offset(contact.dx + ahead * 40, contact.dy - 82);
    limb(canvas, rear, anchors.seat, 8, bike.frame);
    limb(canvas, anchors.seat, head, 10, bike.panel);
    limb(canvas, head, front, 6, bike.frame);
    limb(canvas, head, anchors.leftGrip, 5, bike.frame);
  }

  /// Draws both wheels as dark discs.
  void _sideWheels(Canvas canvas, BikeAnchors anchors) {
    final ahead = -_heading;
    final contact = anchors.wheelContact;
    for (final offset in [-1.0, 1.0]) {
      final centre = Offset(contact.dx + ahead * offset * _wheelBase / 2, contact.dy - _wheelRadius);
      ink
        ..style = PaintingStyle.fill
        ..color = _tyre;
      canvas.drawCircle(centre, _wheelRadius, ink);
      ink.color = bike.panelDark;
      canvas.drawCircle(centre, _wheelRadius * 0.45, ink);
    }
  }
}
