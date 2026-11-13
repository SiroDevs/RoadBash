// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../input/handlebar_pose.dart';
import '../dashboard/dashboard_layout.dart';
import 'handlebar_art.dart';
import 'handlebar_config.dart';

/// Sizes and positions of the handlebar, shared by drawing and touch.
///
/// The handlebar is one rigid piece that turns about a pivot hidden behind the
/// dashboard, so both grips always move together.
class HandlebarLayout {
  HandlebarLayout(this.screen) : dashboard = DashboardLayout(screen) {
    final height = dashboard.ph;
    travel = math.max(height * 0.28, 44.0);
    popupDrop = height * 0.9;
    centreX = screen.x / 2;

    // Width the grips cover, stroke included, so scaling never pushes them off
    // the screen.
    final outer = HandlebarArt.span + HandlebarConfig.gripThicken + 1.0;
    final reach = screen.x * (1 - 2 * _edgeInset);
    final fitted = math.min(height * _gripSize, reach / outer);
    artScale = fitted * HandlebarConfig.scale;
    pipeExtension = reach / artScale - outer;

    pivotY = dashboard.top + height * (_pivotDepth - HandlebarConfig.raise);
    restGripY =
        pivotY +
        (HandlebarArt.rightGripCentre.dy - HandlebarArt.pivot.dy) * artScale;
    halfSpan =
        (HandlebarArt.rightGripCentre.dx -
            HandlebarArt.pivot.dx +
            pipeExtension / 2) *
        artScale;
  }

  final Vector2 screen;
  final DashboardLayout dashboard;

  /// Pixels per art unit, how far a grip may be dragged, how far the handlebar
  /// starts below its resting place, and how many art units the pipe is
  /// stretched to reach the screen edges.
  late final double artScale, travel, popupDrop, pipeExtension;

  /// Screen position of the pivot, of the grips at rest, and the horizontal
  /// distance from the pivot to the middle of a grip.
  late final double centreX, pivotY, restGripY, halfSpan;

  static const double _edgeInset = 0.02;
  static const double _gripSize = 0.013;
  static const double _pivotDepth = 0.2;

  /// Where the handlebar turns about, hidden behind the dashboard.
  Offset get pivot => Offset(centreX, pivotY);

  /// Returns how far the handlebar is turned for a lean from -1 to 1.
  ///
  /// A positive lean turns it clockwise: the right grip goes down and the left
  /// grip goes up, by [travel] pixels at full lean.
  double tilt(double lean) => math.atan2(lean * travel, halfSpan);

  /// Returns the grip's touch area, ending above the accessory row.
  Rect zone(HandlebarSide side) {
    final top = restGripY - travel - dashboard.ph * 0.2;
    final bottom = DashboardLayout.accessoryArea(screen).top;
    return side == HandlebarSide.left
        ? Rect.fromLTRB(0, top, centreX, bottom)
        : Rect.fromLTRB(centreX, top, screen.x, bottom);
  }
}
