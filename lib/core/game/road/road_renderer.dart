// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../../../common/objects/universal/prop_painter.dart';
import '../hud/dashboard/dashboard_layout.dart';
import 'backdrop/road_backdrop.dart';
import 'config/road_config.dart';
import 'config/vehicle_config.dart';
import 'finish/finish_config.dart';
import 'finish/finish_pad_painter.dart';
import 'finish/finish_zone.dart';
import 'road_dynamics.dart';
import 'road_projection.dart';
import 'road_props.dart';
import 'scene_theme.dart';
import 'tarmac/road_segment_painter.dart';
import 'track/road_track.dart';
import 'road_decor_layer.dart';
import 'traffic/road_traffic.dart';
import 'vision_buffer.dart';

/// Draws the road, scenery and traffic of a scene and runs the rider physics.
class RoadRenderer extends PositionComponent with RoadDynamics {
  RoadRenderer(this.theme, {int? laps})
    : track = RoadTrack(theme.id),
      _backdrop = RoadBackdrop(theme),
      _roads = RoadSegmentPainter(theme),
      _decor = PropPainter(theme),
      _pad = FinishPadPainter(theme) {
    props = RoadProps(theme, track);
    finish = FinishZone(
      line: track.finishIndex,
      laps: laps ?? theme.laps,
      lapLength: track.length,
      look: FinishConfig.lookFor(theme.id),
    );
  }

  @override
  final SceneTheme theme;
  final RoadTrack track;
  late final RoadProps props;
  late final FinishZone finish;
  final RoadBackdrop _backdrop;
  final RoadSegmentPainter _roads;
  final PropPainter _decor;
  final FinishPadPainter _pad;
  RoadTraffic? traffic;

  double trkPosition = 0;
  double fullDistance = 0;
  double playerZ = RoadConfig.cameraHeight * RoadConfig.cameraDepth;

  double _spread = 1;

  final VisionBuffer _view = VisionBuffer(RoadConfig.drawDistance);
  late final RoadDecorLayer _decorLayer = RoadDecorLayer(
    track,
    props,
    finish,
    _decor,
  );
  final _p1 = ProjectionPoint();
  final _p2 = ProjectionPoint();

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _backdrop.resize(size);
    playerZ = DashboardLayout.cameraDistance(size);
    _spread = DashboardLayout.roadSpread(size);
  }

  @override
  void update(double dt) {
    final seg = track.at(trkPosition + playerZ);
    steerToward(dt, locked || (crashed && !recovering) ? 0 : steer);
    if (locked && !recovering) {
      speed = 0;
      skidding = false;
      curveFelt += (0 - curveFelt) * math.min(1.0, dt * 4);
      settleRpm(dt, throttle ? 0.30 : 0.16);
      return;
    }
    if (recovering) {
      stepDynamics(dt, seg, speedPercent);
      if (!recovering) return;
      speed = 0;
      trkPosition =
          (trkPosition + dt * VehicleConfig.maxSpeed * 0.12) % track.length;
      _backdrop.scroll += dt * 18;
      return;
    }
    final sp = speedPercent;
    final step = dt * speed;
    trkPosition = (trkPosition + step) % track.length;
    fullDistance += step;
    finish.update(trkPosition, fullDistance);

    curveFelt += (seg.curve - curveFelt) * math.min(1.0, dt * 3.5);

    stepDynamics(dt, seg, sp);
    if (recovering) {
      speed = 0;
      return;
    }
    _backdrop.scroll += curveFelt * sp * dt * 34;
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0 || size.y <= 0) return;
    _backdrop.skylineRise = finish.rise;
    _backdrop.draw(canvas, size);

    const len = RoadConfig.segmentLength;
    final baseIdx = track.indexAt(trkPosition);
    final base = track.segments[baseIdx];
    final basePercent = (trkPosition % len) / len;
    final pz = trkPosition + playerZ;
    final pSeg = track.at(pz);
    final playerY = pSeg.y1 + (pSeg.y2 - pSeg.y1) * ((pz % len) / len);

    var curveOffset = 0.0;
    var dx = -(base.curve * basePercent);
    var maxY = size.y;
    _view.reset();

    for (var n = 0; n < RoadConfig.drawDistance; n++) {
      final seg = track.segments[(baseIdx + n) % track.count];
      final looped = seg.index < baseIdx;
      final camX = playerX * RoadConfig.roadWidth - curveOffset;
      final camY = playerY + RoadConfig.cameraHeight;
      final camZ = trkPosition - (looped ? track.length : 0);

      final camX2 = camX - dx;
      _p1.project(seg.y1, seg.index * len, camX, camY, camZ, size, _spread);
      _p2.project(
        seg.y2,
        (seg.index + 1) * len,
        camX2,
        camY,
        camZ,
        size,
        _spread,
      );
      curveOffset += dx;
      dx += seg.curve;

      if (_p1.z < RoadConfig.nearClip) {
        if (_p2.z <= RoadConfig.nearClip) continue;
        final clipRatio = (RoadConfig.nearClip - _p1.z) / (_p2.z - _p1.z);
        _p1.project(
          seg.y1 + (seg.y2 - seg.y1) * clipRatio,
          camZ + RoadConfig.nearClip,
          camX + (camX2 - camX) * clipRatio,
          camY,
          camZ,
          size,
          _spread,
        );
      }
      if (_p2.y >= _p1.y || _p2.y >= maxY) continue;

      final vision = _view.add(n)..fill(seg, n, _p1, _p2, maxY);
      _roads.draw(canvas, vision, size.x);
      if (finish.on) {
        final row = finish.padRow(seg.index);
        if (row >= 0)
          _pad.draw(canvas, vision, row, zebra: finish.isZebra(row));
      }
      maxY = _p2.y;
      if (vision.fog >= 1) break;
    }

    if (_view.count > 0) {
      traffic?.prepare(trkPosition, fullDistance, playerZ, props, baseIdx);
      traffic?.locateBehind(_view.at, size);
      _decor.drawCliffs(canvas, _view.segments, _view.count, size);
      _decorLayer.draw(canvas, _view, baseIdx, size, traffic);
    }
  }
}
