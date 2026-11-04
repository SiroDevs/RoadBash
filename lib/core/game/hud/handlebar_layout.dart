// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../input/handlebar_pose.dart';
import 'dashboard_layout.dart';
import 'handlebar_art.dart';

/// Sizes and positions of the handlebars, shared by drawing and touch.
class HandlebarLayout {
  HandlebarLayout(this.screen) : dashboard = DashboardLayout(screen) {
    final height = dashboard.ph;
    travel = math.max(height * 0.28, 44.0);
    popupDrop = height * 0.9;
    centreX = screen.x / 2;
    barLength = _endX(HandlebarSide.right) - _pivotX(HandlebarSide.right);
    artScale = math.min(height * _gripSize, barLength / HandlebarArt.length);
    pipeExtension = math.max(0.0, barLength / artScale - HandlebarArt.length);
    pivotY = dashboard.top + height * _pipeDepth;
    restEndY = pivotY - barLength * 0.005;
  }

  final Vector2 screen;
  final DashboardLayout dashboard;

  late final double travel, popupDrop, barLength, artScale, pipeExtension;
  late final double centreX, pivotY, restEndY;

  static const double _edgeInset = 0.02;
  static const double _gripSize = 0.0215;
  static const double _pipeDepth = 1.2;
  static const double _pivotSpread = -0.2;

  /// Returns -1 for the left bar and 1 for the right bar.
  static double sign(HandlebarSide side) =>
      side == HandlebarSide.left ? -1 : 1;

  /// Returns the horizontal position of a bar's grip end.
  double _endX(HandlebarSide side) => side == HandlebarSide.left
      ? screen.x * _edgeInset
      : screen.x * (1 - _edgeInset);

  /// Returns the horizontal position of a bar's inner end, behind the dashboard.
  double _pivotX(HandlebarSide side) =>
      centreX + sign(side) * dashboard.pw * _pivotSpread;

  /// Returns where a bar pivots, behind the dashboard above the meters.
  Offset pivot(HandlebarSide side) => Offset(_pivotX(side), pivotY);

  /// Returns a bar's grip end for a vertical offset from -1 (up) to 1 (down).
  Offset end(HandlebarSide side, double offset) =>
      Offset(_endX(side), restEndY + offset * travel);

  /// Returns the screen area that grabs a bar.
  Rect zone(HandlebarSide side) {
    final top = restEndY - travel - dashboard.ph * 0.2;
    return side == HandlebarSide.left
        ? Rect.fromLTRB(0, top, centreX, screen.y)
        : Rect.fromLTRB(centreX, top, screen.x, screen.y);
  }
}