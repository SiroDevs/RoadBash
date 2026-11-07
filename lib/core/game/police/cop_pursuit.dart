// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../../../common/objects/guardrail/guardrail_config.dart';
import '../road/config/vehicle_config.dart';
import '../road/road_renderer.dart';
import '../road/traffic/traffic_flow.dart';
import 'police_cop.dart';

/// Where the cop rides in relation to the player.
///
/// A cop trails behind a rider who keeps up speed, gets in front of one who
/// slows down to block the way, and rides alongside one who is arrested.
enum CopStance { trail, block, escort }

/// Rides the cop toward its place around the player.
class CopPursuit {
  const CopPursuit();

  static const double _topShare = 0.975;
  static const double _closeGain = 2.8;
  static const double _trailGap = 1800;
  static const double _blockGap = 700;
  static const double _sideOffset = 0.55;
  static const double _edge = 0.9;
  static const double _alongsideReach = 2500;

  /// Rides [cop] for one frame and returns where it is relative to the player.
  double ride(
    double dt,
    PoliceCop cop,
    RoadRenderer road,
    TrafficFlow flow,
    CopStance stance,
  ) {
    final along = cop.distance - road.fullDistance;
    final goal = switch (stance) {
      CopStance.trail => -_trailGap,
      CopStance.block => _blockGap,
      CopStance.escort => 0.0,
    };
    final top = VehicleConfig.maxSpeed * _topShare;
    var want = (road.speed - (along - goal) * _closeGain)
        .clamp(0.0, top)
        .toDouble();

    final seg = road.track.at(cop.distance + road.playerZ);
    final limit = road.theme.dualCarriageway
        ? GuardrailConfig.riderLimit(seg.section)
        : null;
    final maxLateral = math.min(_edge, (limit ?? 9.0) - 0.12);

    var line = road.playerX;
    final beside = stance == CopStance.block
        ? along < _blockGap * 0.25
        : along > -_alongsideReach;
    if (beside) {
      final side = road.playerX > 0 ? -1.0 : 1.0;
      line = road.playerX + side * _sideOffset;
      if (line.abs() > maxLateral) line = road.playerX - side * _sideOffset;
    }
    line = flow.freeLine(cop.distance, cop.lateral, line, limit: maxLateral) ??
        line;
    final cap = flow.speedCap(cop.distance, cop.lateral);
    if (cap != null) want = math.min(want, cap);

    cop.advance(
      dt,
      targetSpeed: want,
      targetLateral: line,
      maxLateral: maxLateral,
      curve: seg.curve,
    );
    return cop.distance - road.fullDistance;
  }
}
