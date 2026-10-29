// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import '../hud/dashboard_layout.dart';
import 'backdrop/road_backdrop.dart';
import 'config/road_config.dart';
import 'finish/finish_config.dart';
import 'finish/finish_pad_painter.dart';
import 'finish/finish_zone.dart';
import 'props/painters/prop_painter.dart';
import 'props/road_props.dart';
import 'road_dynamics.dart';
import 'road_projection.dart';
import 'scene_theme.dart';
import 'surface/road_segment_painter.dart';
import 'track/road_track.dart';
import 'traffic/road_traffic.dart';

class RoadRenderer extends PositionComponent with RoadDynamics {
  RoadRenderer(this.theme)
    : track = RoadTrack(theme.id),
      _backdrop = RoadBackdrop(theme),
      _roads = RoadSegmentPainter(theme),
      _decor = PropPainter(theme),
      _pad = FinishPadPainter(theme) {
    props = RoadProps(theme, track);
    finish = FinishZone(
      line: track.finishIndex,
      laps: theme.laps,
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

  final List<VisionSeg> _vis = List.generate(
    RoadConfig.drawDistance,
    (_) => VisionSeg(),
  );
  final List<VisionSeg?> _byN = List.filled(RoadConfig.drawDistance, null);
  int _visCount = 0;
  int _firstN = 0;
  int _lastN = 0;
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
    steerToward(dt, locked ? 0 : steer);
    if (locked) {
      speed = 0;
      skidding = false;
      curveFelt += (0 - curveFelt) * math.min(1.0, dt * 4);
      settleRpm(dt, throttle ? 0.30 : 0.16);
      return;
    }
    final sp = speedPercent;
    final step = dt * speed;
    trkPosition = (trkPosition + step) % track.length;
    fullDistance += step;
    finish.update(trkPosition, fullDistance);

    curveFelt += (seg.curve - curveFelt) * math.min(1.0, dt * 3.5);

    stepDynamics(dt, seg, sp);
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
    _visCount = 0;
    _firstN = -1;
    _lastN = -1;
    _byN.fillRange(0, _byN.length, null);

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

      final vision = _vis[_visCount++]..fill(seg, n, _p1, _p2, maxY);
      _byN[n] = vision;
      if (_firstN < 0) _firstN = n;
      _lastN = n;
      _roads.draw(canvas, vision, size.x);
      if (finish.on) {
        final row = finish.padRow(seg.index);
        if (row >= 0) _pad.draw(canvas, vision, row, zebra: finish.isZebra(row));
      }
      maxY = _p2.y;
      if (vision.fog >= 1) break;
    }

    if (_visCount > 0) {
      traffic?.prepare(trkPosition, fullDistance, playerZ);
      _drawDecor(canvas, baseIdx);
    }
  }

  void _drawDecor(Canvas canvas, int baseIdx) {
    final near = _byN[_firstN]!;
    final limit = math.min(RoadConfig.decorDistance, _lastN + 1);

    for (var n = limit - 1; n >= -RoadConfig.maxPropDepth; n--) {
      final anchor = n < _firstN ? near : _byN[n];
      if (anchor != null) traffic?.paintAt(canvas, n, anchor, size);

      final list = props.at((baseIdx + n + track.count * 2) % track.count);
      if (list.isEmpty) continue;
      if (anchor == null) continue;

      for (final prop in list) {
        if (!finish.shows(prop)) continue;
        if (prop.depth == 0) {
          _decor.drawBillboard(canvas, anchor, prop, size);
          continue;
        }
        final backN = math.min(n + prop.depth, _lastN);
        if (backN <= _firstN) continue;
        final back = _byN[backN] ?? _findBack(backN);
        if (back == null || back == anchor) continue;
        _decor.drawBox(canvas, anchor, back, prop, size);
      }
    }
  }

  VisionSeg? _findBack(int index) {
    for (var i = index; i >= _firstN; i--) {
      final vision = _byN[i];
      if (vision != null) return vision;
    }
    return null;
  }
}
