// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';
import 'race_controller.dart';
import 'rival_pace.dart';
import 'rival_sight.dart';

/// The mind of one rival: it decides how fast to ride and which line to take.
class RivalBrain {
  RivalBrain(this.rival, int seed) : _random = math.Random(seed) {
    final focus = rival.focus;
    _reaction = 0.2 + 0.3 * (1 - focus);
    _launchDelay = 0.05 + 0.4 * _random.nextDouble() * (1.2 - focus);
    launchPower = 0.85 + 0.2 * _random.nextDouble();
    _pace = RivalPace(rival, _random);
    _thinkTimer = _random.nextDouble() * _reaction;
  }

  static const double _referenceSpeed = VehicleConfig.maxSpeed * 0.5;
  static const double _tacticsDelay = 3;
  static const double _draftRange = 0.45;
  static const double _blockRange = 1.4;
  static const double _yieldRange = 0.3;
  static const double _passOffset = 0.6;
  static const double _mistakeChance = 0.02;
  static const double _attackAlong = 600;
  static const double _attackSide = 1.0;
  static const double _grudgeFade = 0.02;

  final RiderRival rival;
  final math.Random _random;
  late final RivalPace _pace;
  late final double _reaction;
  late final double _launchDelay;
  late final double launchPower;

  RivalMood mood = RivalMood.cruise;
  double speedFraction = 0;
  double? preferredLine;

  double _clock = 0;
  double _thinkTimer = 0;
  double _moodTimer = 0;
  double _slipTimer = 0;
  double _urgency = 0.6;
  double _attackCooldown = 2;
  double _grudge = 0;
  bool _yielding = false;

  /// Lets the rival look around, decide and set its speed and line.
  void think(double dt, RivalSight sight) {
    _clock += dt;
    _thinkTimer -= dt;
    _moodTimer -= dt;
    _attackCooldown -= dt;
    _grudge = math.max(0.0, _grudge - _grudgeFade * dt);
    if (_slipTimer > 0) {
      _slipTimer -= dt;
      if (_slipTimer <= 0) _enter(RivalMood.cruise, 0.5);
    }
    if (_thinkTimer <= 0) {
      _decide(sight);
      _thinkTimer = _reaction * (0.6 + 0.8 * _random.nextDouble());
    }
    speedFraction = _clock < _launchDelay
        ? 0
        : _pace.target(sight, mood, _clock, _urgency, yielding: _yielding);
    _pace.spend(dt, mood.pushing);
  }

  /// Reacts to a collision: attackers back off, victims hold a grudge.
  void collided({required bool attacker}) {
    if (attacker) {
      _attackCooldown = 5 + 4 * _random.nextDouble();
      if (mood == RivalMood.attack) _enter(RivalMood.cruise, 1);
      return;
    }
    _grudge = 0.3;
    _attackCooldown = 0.5;
  }

  /// Picks a mood from the gap to the player and the riders around.
  void _decide(RivalSight sight) {
    if (_slipTimer > 0 || _clock < _launchDelay + _tacticsDelay) return;
    final slipChance = _mistakeChance * (1 - rival.focus);
    if (sight.ownSpeed > _referenceSpeed && _random.nextDouble() < slipChance) {
      _slipTimer = 0.7 + _random.nextDouble();
      _enter(RivalMood.slip, _slipTimer);
      preferredLine = sight.ownLateral + _random.nextDouble() - 0.5;
      return;
    }
    if (_tryAttack(sight)) return;
    final gap = sight.deficit / _referenceSpeed;
    if (mood == RivalMood.cruise || mood == RivalMood.chase) {
      preferredLine = null;
    }
    _urgency = gap > 0 ? (gap / 3).clamp(0.4, 1.0).toDouble() : 0.8;
    if (gap > 0) {
      _chase(sight, gap);
    } else {
      _lead(sight, -gap);
    }
    _avoidPeer(sight);
  }

  /// Rival is behind the player: close in, sit in the slipstream, then pass.
  void _chase(RivalSight sight, double gap) {
    final onLine = (sight.playerLateral - sight.ownLateral).abs() < 0.45;
    if (mood == RivalMood.draft) {
      if (gap > 0.7) {
        _enter(RivalMood.chase, 0);
      } else if (_moodTimer <= 0) {
        _enter(RivalMood.overtake, 1.5 + 1.5 * _random.nextDouble());
        preferredLine = _passLine(sight);
      } else {
        preferredLine = sight.playerLateral;
      }
    } else if (mood == RivalMood.overtake) {
      if (_moodTimer <= 0 || gap > 0.9) {
        _enter(RivalMood.chase, 0);
      } else {
        preferredLine = _passLine(sight);
      }
    } else if (gap < _draftRange && onLine) {
      _enter(RivalMood.draft, 0.6 + 1.2 * _random.nextDouble());
      preferredLine = sight.playerLateral;
    } else if (mood != RivalMood.chase) {
      _enter(RivalMood.chase, 0);
    }
  }

  /// Rival is ahead of the player: hold the lead, or block if threatened.
  void _lead(RivalSight sight, double leadSeconds) {
    final threatened = leadSeconds < _blockRange;
    if (mood == RivalMood.defend) {
      if (!threatened || _moodTimer <= 0) {
        _enter(RivalMood.cruise, 1 + 2 * _random.nextDouble());
      } else {
        preferredLine = sight.playerLateral;
      }
      return;
    }
    final blockChance = 0.35 + 0.6 * rival.aggression;
    if (threatened && _moodTimer <= 0 && _random.nextDouble() < blockChance) {
      _enter(RivalMood.defend, 2 + 3 * rival.aggression);
      preferredLine = sight.playerLateral;
    } else if (mood != RivalMood.cruise) {
      _enter(RivalMood.cruise, 0.5);
    }
  }

  /// Moves off the line when another rival is just ahead in the same lane.
  void _avoidPeer(RivalSight sight) {
    final gap = sight.peerGapSeconds;
    _yielding = gap != null && gap < _yieldRange;
    if (!_yielding) return;
    final direction = sight.ownLateral >= sight.peerLateral ? 1.0 : -1.0;
    final line = sight.ownLateral + direction * 0.55;
    preferredLine = line.abs() > 0.9 ? sight.ownLateral - direction * 0.55 : line;
  }

  /// Returns the line beside the player that the rival passes on.
  double _passLine(RivalSight sight) {
    final side = sight.ownLateral >= sight.playerLateral ? 1.0 : -1.0;
    final line = sight.playerLateral + side * _passOffset;
    return line.abs() > 0.9 ? sight.playerLateral - side * _passOffset : line;
  }

  /// Leans into the player when level with him, trying to knock him aside.
  bool _tryAttack(RivalSight sight) {
    final level = sight.deficit.abs() < _attackAlong &&
        (sight.ownLateral - sight.playerLateral).abs() < _attackSide;
    if (mood == RivalMood.attack) {
      if (_moodTimer > 0 && level) {
        preferredLine = sight.playerLateral;
        return true;
      }
      _attackCooldown = 3 + 3 * _random.nextDouble();
      _enter(RivalMood.cruise, 0.5);
      return false;
    }
    if (!level || _attackCooldown > 0) return false;
    final chance = 0.04 + 0.12 * rival.aggression + _grudge;
    if (_random.nextDouble() >= chance) return false;
    _enter(RivalMood.attack, 1.4 + rival.aggression);
    preferredLine = sight.playerLateral;
    return true;
  }

  void _enter(RivalMood next, double duration) {
    mood = next;
    _moodTimer = duration;
    preferredLine = null;
  }
}
