// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';

/// Latest distance, speed and finish time reported by each rival.
class RivalTracker {
  final Map<String, _RivalStatus> _byName = {};

  /// Records where a rival is and how fast it rides.
  void report(String name, double distance, double speed) {
    final status = _byName.putIfAbsent(name, _RivalStatus.new);
    status.distance = distance;
    status.speed = speed;
  }

  /// Records the time at which a rival crossed the finish line.
  void markFinished(String name, double time) {
    _byName.putIfAbsent(name, _RivalStatus.new).finishTime ??= time;
  }

  /// Returns how far a rival has ridden.
  double distanceOf(String name) => _byName[name]?.distance ?? 0;

  /// Returns the finish time of a rival, estimated if it is still riding.
  double finishTimeOf(String name, double raceLength, double now) {
    final status = _byName[name];
    if (status == null) return now;
    final recorded = status.finishTime;
    if (recorded != null) return recorded;
    final remaining = math.max(0.0, raceLength - status.distance);
    final pace = math.max(status.speed, VehicleConfig.maxSpeed * 0.35);
    return now + remaining / pace;
  }
}

class _RivalStatus {
  double distance = 0;
  double speed = 0;
  double? finishTime;
}
