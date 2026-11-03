// Dart imports:
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../../domain/models/scene_id.dart';
import '../hud/dashboard_layout.dart';
import '../rider/dust_trail.dart';
import '../rider/look/rider_look.dart';
import '../rider/look/rider_looks.dart';
import '../rider/rider_rig.dart';
import '../rider/rider_sprite.dart';
import '../road/road_renderer.dart';
import '../road/scene_theme.dart';
import '../road/traffic/road_traffic.dart';
import '../road/universal/config/vehicle_config.dart';
import 'preview_bike.dart';

/// Stills of each scene, drawn by the game's own road code with the main rider
/// somewhere in the middle of the course. Only the rider is the same in every
/// still.
abstract final class SceneSnapshot {
  static const double width = 800;
  static const double height = 600;
  static const double _riderSpeed = 0.78;

  static const Map<SceneId, double> _courseShare = {
    SceneId.city: 0.5,
    SceneId.suburbs: 0.5,
    SceneId.thikaRoad: 0.4,
    SceneId.jungle: 0.16,
    SceneId.dirtRoad: 0.45,
  };

  static final Map<SceneId, Image> _done = {};
  static final Map<SceneId, Future<Image>> _pending = {};
  static Future<void> _queue = Future.value();

  /// Returns the still of [scene], drawing it the first time it is asked for.
  static Future<Image> of(SceneId scene) {
    final done = _done[scene];
    if (done != null) return Future.value(done);
    return _pending.putIfAbsent(scene, () {
      final result = _queue.then((_) => _draw(scene));
      _queue = result.then((_) {}, onError: (_) {});
      return result;
    });
  }

  /// Returns the still of [scene] if it has already been drawn.
  static Image? cached(SceneId scene) => _done[scene];

  /// Starts drawing every scene one after the other, so they are ready early.
  static void warmUp(Iterable<SceneId> scenes) {
    for (final scene in scenes) {
      unawaited(of(scene).then((_) {}, onError: (_) {}));
    }
  }

  /// Draws one still: the road at its place, rivals ahead, then the rider.
  static Future<Image> _draw(SceneId scene) async {
    await Future<void>.delayed(Duration.zero);
    final theme = SceneTheme.of(scene);
    final size = Vector2(width, height);
    final road = RoadRenderer(theme)..onGameResize(size);
    final at = road.track.length * (_courseShare[scene] ?? 0.5);
    final ground = road.track.at(at + road.playerZ).ground;
    road
      ..trkPosition = at
      ..fullDistance = at
      ..playerX = ground.hasLane ? ground.laneCenter : 0.0
      ..speed = VehicleConfig.maxSpeed * _riderSpeed
      ..traffic = RoadTraffic(_rivals(at, theme.lanes), theme.lanes);

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    road.render(canvas);
    _paintRider(canvas, road, size, ground.terrain.dusty, ground.terrain.dustTone);
    final image = await recorder.endRecording().toImage(width.round(), height.round());
    _done[scene] = image;
    return image;
  }

  /// Places a few rivals ahead of the rider.
  static List<PreviewBike> _rivals(double at, int lanes) {
    const looks = [RiderLooks.mike, RiderLooks.sam, RiderLooks.brayo];
    const gaps = [2600.0, 4400.0, 7200.0];
    const sides = [-0.45, 0.4, -0.1];
    return [
      for (var index = 0; index < looks.length; index++)
        PreviewBike(
          distance: at + gaps[index],
          lateral: sides[index],
          look: looks[index],
          speed: 0.75,
        ),
    ];
  }

  /// Paints the main rider and, on loose ground, the dust behind the bike.
  static void _paintRider(Canvas canvas, RoadRenderer road, Vector2 size, bool dusty, Color tone) {
    final lane = DashboardLayout.lanePx(size, road.theme.lanes);
    final riderHeight = RiderRig.heightFor(lane, size.y);
    final ground = Offset(size.x / 2, DashboardLayout.riderTyresGround(size));
    final sprite = RiderSprite(look: RiderLook.main);
    final curve = road.track.at(road.trkPosition + road.playerZ).curve;
    sprite.pose
      ..speed = _riderSpeed
      ..lean = (curve * 0.04 * _riderSpeed).clamp(-0.3, 0.3).toDouble()
      ..phase = 0.3;
    sprite.paintAt(canvas, ground, riderHeight / RiderSprite.height);
    if (!dusty) return;
    final dust = DustTrail();
    for (var step = 0; step < 50; step++) {
      dust.update(0.02, emitting: true, strength: math.min(1.0, _riderSpeed + 0.2));
    }
    dust.paint(canvas, ground, riderHeight, tone);
  }
}
