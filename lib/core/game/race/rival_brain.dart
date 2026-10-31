// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../road/config/vehicle_config.dart';
import 'race_controller.dart';
import 'rival_sight.dart';

/// The mind of one rival: it decides how fast to ride and which line to take.
class RivalBrain {
  RivalBrain(this.rival, int seed) : _random = math.Random(seed) {
    final focus = rival.focus;
    _reaction = 0.2 + 0.3 * (1 - focus);
    _launchDelay = 0.05 + 0.4 * _random.nextDouble() * (1.2 - focus);
    launchPower = 0.85 + 0.2 * _random.nextDouble();
    _surgeRate = 0.25 + 0.3 * _random.nextDouble();
    _surgePhase = _random.nextDouble() * math.pi * 2;
    _surgeDepth = 0.02 + 0.03 * (1 - focus);
    _thinkTimer = _random.nextDouble() * _reaction;
  }

  static const double _referenceSpeed = VehicleConfig.maxSpeed * 0.5;
  static const double _tacticsDelay = 3;
  static const double _draftRange = 0.45;
  static const double _blockRange = 1.4;
  static const double _yieldRange = 0.3;
  static const double _passOffset = 0.6;
  static const double _mistakeChance = 0.02;
  static const double _boostLimit = 0.14;
  static const double _slipstream = 0.035;
  static const double _conserve = 0.96;
  static const double _slipFactor = 0.72;
  static const double _yieldFactor = 0.92;
  static const double _sprintFrom = 0.92;
  static const double _drain = 0.07;
  static const double _recover = 0.05;

  final RiderRival rival;
  final math.Random _random;
  late final double _reaction;
  late final double _launchDelay;
  late final double _surgeRate;
  late final double _surgePhase;
  late final double _surgeDepth;
  late final double launchPower;

  RivalMood mood = RivalMood.cruise;
  double speedFraction = 0;
  double? preferredLine;

  double _clock = 0;
  double _thinkTimer = 0;
  double _moodTimer = 0;
  double _slipTimer = 0;
  double _energy = 1;
  double _urgency = 0.6;
  bool _tired = false;
  bool _yielding = false;

  bool get _pushing =>
      mood == RivalMood.chase ||
      mood == RivalMood.overtake ||
      mood == RivalMood.defend;

  /// Lets the rival look around, decide and set its speed and line.
  void think(double dt, RivalSight sight) {
    _clock += dt;
    _thinkTimer -= dt;
    _moodTimer -= dt;
    if (_slipTimer > 0) {
      _slipTimer -= dt;
      if (_slipTimer <= 0) _enter(RivalMood.cruise, 0.5);
    }
    if (_thinkTimer <= 0) {
      _decide(sight);
      _thinkTimer = _reaction * (0.6 + 0.8 * _random.nextDouble());
    }
    speedFraction = _clock < _launchDelay ? 0 : _paceFor(sight);
    _spendEnergy(dt);
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

  /// Returns the target speed as a fraction of the top speed.
  double _paceFor(RivalSight sight) {
    final surge = 1 + _surgeDepth * math.sin(_surgeRate * _clock + _surgePhase);
    var fraction = rival.pace * surge;
    final sprinting = sight.raceFraction > _sprintFrom;
    if ((_pushing && !_tired) || sprinting) {
      fraction += rival.grit * _boostLimit * _urgency;
    }
    if (mood == RivalMood.draft) fraction += _slipstream;
    if (mood == RivalMood.cruise) fraction *= _conserve;
    if (mood == RivalMood.slip) fraction *= _slipFactor;
    if (_yielding) fraction *= _yieldFactor;
    return fraction.clamp(0.25, 1.02).toDouble();
  }

  /// Pushing hard tires the rival; easing off lets it recover.
  void _spendEnergy(double dt) {
    final change = _pushing ? -_drain * (1.2 - rival.grit * 0.5) : _recover;
    _energy = (_energy + change * dt).clamp(0.0, 1.0).toDouble();
    if (_energy <= 0.05) _tired = true;
    if (_energy >= 0.5) _tired = false;
  }

  void _enter(RivalMood next, double duration) {
    mood = next;
    _moodTimer = duration;
    preferredLine = null;
  }
}
