// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/game.dart';
import 'package:flame/input.dart';

// Project imports:
import '../../domain/models/level_rules.dart';
import '../../domain/models/player_profile.dart';
import '../../domain/models/scene_id.dart';
import '../audio/audio_service.dart';
import 'audio/ride_audio.dart';
import 'hud/dashboard/dashboard_hud.dart';
import 'hud/handlebar/handlebar_grips_hud.dart';
import 'hud/handlebar/handlebar_pipe_hud.dart';
import 'hud/handlebar/handlebar_rig.dart';
import 'hud/hud_strings.dart';
import 'input/road_input.dart';
import 'police/police_chase.dart';
import 'race/race_controller.dart';
import 'race/race_pause.dart';
import 'race/race_result.dart';
import 'race/race_world.dart';
import 'race/rider_contacts.dart';
import 'race/rival/rival_racer.dart';
import 'race/traffic_contacts.dart';
import 'race/wrong_side_watch.dart';
import 'rider/rider_component.dart';
import 'road/road_renderer.dart';
import 'road/traffic/rival_overlay.dart';
import 'road/traffic/traffic_flow.dart';

/// Flame game that runs a race on the road.
class RoadGame extends FlameGame with KeyboardEvents, RoadInput, RacePause {
  RoadGame({
    required this.scene,
    required this.mix,
    required this.audio,
    required this.strings,
    required this.playerName,
    required this.onFinished,
    required this.rules,
    this.briefing = const [],
    this.onPauseKey,
  });

  /// How long the pre-race hints stay up before the countdown starts.
  static const double briefingSeconds = 4.0;

  final SceneId scene;

  /// The rules of the level being raced.
  final LevelRules rules;

  /// Hint lines shown before the countdown; the first is the level's title.
  final List<String> briefing;
  PlayerProfile mix;
  final AudioService audio;
  final HudStrings strings;
  final String playerName;
  final ValueChanged<RaceResult> onFinished;
  final VoidCallback? onPauseKey;

  @override
  late final RoadRenderer road;
  late final RaceController race;
  late final List<RivalRacer> racers;

  /// Civilian vehicles sharing the road with the race.
  late final TrafficFlow flow;

  /// The police patrol that chases a speeding or reckless player.
  late final PoliceChase police;
  late final TrafficContacts _trafficContacts;
  late final RaceWorld _world;
  final WrongSideWatch _wrongSide = WrongSideWatch();
  RideAudio? _ride;

  @override
  RideAudio? get ride => _ride;
  late final RiderContacts _contacts = RiderContacts(
    onImpact: (strength, knockedOff) => _ride?.impact(strength, knockedOff),
    onBash: () {
      race.bashes++;
      police.bash();
    },
    shoving: rules.shoving,
  );

  bool _notified = false;
  bool _shutDown = false;
  double _finishDelay = 2.4;

  @override
  Future<void> onLoad() async {
    final world = RaceWorld.build(
      scene: scene,
      rules: rules,
      playerName: playerName,
      briefingSeconds: briefing.isEmpty ? 0 : briefingSeconds,
    );
    _world = world;
    road = world.road;
    race = world.race;
    racers = world.racers;
    flow = world.flow;
    police = world.police;
    _trafficContacts = TrafficContacts(
      onImpact: (strength, knockedOff) => _ride?.impact(strength, knockedOff),
      onHit: () => race.trafficHits++,
    );
    final handlebar = HandlebarRig(road, () => handlebars);
    await addAll([
      road,
      RiderComponent(road),
      RivalOverlay(road),
      handlebar,
      HandlebarPipeHud(handlebar),
      DashboardHud(road, race, strings, police, briefing),
      HandlebarGripsHud(handlebar, strings.gas),
    ]);
    if (_shutDown) return;
    final ride = RideAudio(
      mix: mix,
      service: audio,
      road: road,
      race: race,
      racers: racers,
      police: police,
    );
    _ride = ride;
    unawaited(ride.start());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLoaded) return;

    road.locked = race.countdown > 0;
    applyInput();
    race.update(dt, road.fullDistance, road.speed);
    flow.update(race.countdown > 0 ? 0 : dt, road.fullDistance, road.playerZ);
    for (final r in racers) {
      r.update(dt, race, road);
    }
    if (road.recovering) _world.checkRunnerHazards();
    _contacts.update(dt, race, road, racers, attack: attack);
    _trafficContacts.update(dt, race, road, flow, racers, police);
    _wrongSide.update(dt, race, road, flow);
    police.update(dt, race, road, flow);
    if (police.busted && !race.finished) race.bust(police.fine);
    if (race.finished && !finishing) {
      finishing = true;
      if (race.endedEarly) _finishDelay = 3.4;
      applyInput();
    }
    if (finishing &&
        !_notified &&
        (_finishDelay -= dt) <= 0 &&
        (race.endedEarly || _fieldHome)) {
      _notified = true;
      onFinished(race.buildResult());
    }
    _ride?.update(dt);
  }

  /// True when the finish delay is over or every rival has settled.
  bool get _fieldHome =>
      _finishDelay < -3.6 || racers.every((r) => r.settled);

  /// Applies a new player profile to the game and its audio.
  void updateMix(PlayerProfile profile) {
    mix = profile;
    _ride?.mix = profile;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      onPauseKey?.call();
      return KeyEventResult.handled;
    }
    readKeys(keysPressed);
    return KeyEventResult.handled;
  }

  /// Stops audio and releases the game's resources.
  Future<void> shutdown() async {
    _shutDown = true;
    final ride = _ride;
    _ride = null;
    await ride?.dispose();
  }
}
