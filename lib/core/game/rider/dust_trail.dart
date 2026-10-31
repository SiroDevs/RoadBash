// Dart imports:
import 'dart:math' as math;
import 'dart:ui';

/// Puffs of dust a bike kicks up from its rear wheel.
class DustTrail {
  static const int _capacity = 36;
  static const double _perSecond = 46;

  final math.Random _random = math.Random();
  final List<_Puff> _puffs = List.generate(_capacity, (_) => _Puff());
  final Paint _paint = Paint();
  double _carry = 0;

  /// Moves the puffs on and adds new ones while [emitting].
  void update(double dt, {required bool emitting, required double strength}) {
    for (final puff in _puffs) {
      if (!puff.alive) continue;
      puff
        ..age += dt
        ..rise += puff.riseSpeed * dt
        ..drift += puff.driftSpeed * dt;
    }
    if (!emitting) {
      _carry = 0;
      return;
    }
    _carry += _perSecond * strength * dt;
    while (_carry >= 1) {
      _carry -= 1;
      _spawn();
    }
  }

  /// Paints the puffs behind a bike whose wheels touch [ground] and which is
  /// [height] tall.
  void paint(Canvas canvas, Offset ground, double height, Color tone) {
    for (final puff in _puffs) {
      if (!puff.alive) continue;
      final share = puff.age / puff.life;
      final fadeIn = share < 0.15 ? share / 0.15 : 1.0;
      final alpha = 0.5 * (1 - share) * fadeIn;
      _paint.color = tone.withAlpha((alpha * 255).round().clamp(0, 255));
      canvas.drawCircle(
        Offset(ground.dx + puff.drift * height, ground.dy - puff.rise * height),
        (puff.size + 0.16 * share) * height,
        _paint,
      );
    }
  }

  /// Starts a puff in the first free slot.
  void _spawn() {
    for (final puff in _puffs) {
      if (puff.alive) continue;
      puff
        ..age = 0
        ..life = 0.55 + 0.5 * _random.nextDouble()
        ..rise = 0.02
        ..riseSpeed = 0.25 + 0.35 * _random.nextDouble()
        ..drift = (_random.nextDouble() - 0.5) * 0.2
        ..driftSpeed = (_random.nextDouble() - 0.5) * 0.5
        ..size = 0.05 + 0.05 * _random.nextDouble();
      return;
    }
  }
}

class _Puff {
  double age = 1;
  double life = 0;
  double rise = 0;
  double riseSpeed = 0;
  double drift = 0;
  double driftSpeed = 0;
  double size = 0;

  bool get alive => age < life;
}
