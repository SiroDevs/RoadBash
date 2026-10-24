// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../../l10n/l10n_extension.dart';
import '../hud/dashboard_layout.dart';

class TouchControls extends StatelessWidget {
  const TouchControls({
    super.key,
    required this.showSteering,
    required this.onSteer,
    required this.onThrottle,
    required this.onBrake,
  });

  final bool showSteering;
  final ValueChanged<double> onSteer;
  final ValueChanged<bool> onThrottle;
  final ValueChanged<bool> onBrake;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, box) {
        final screen = Vector2(box.maxWidth, box.maxHeight);
        final pad = MediaQuery.paddingOf(context);
        final unit = math.min(box.maxWidth, box.maxHeight);

        final pedalW = (unit * 0.2).clamp(40.0, 75.0).toDouble();
        final pedalH = pedalW * 1.2;
        final arrow = pedalW * 0.74;

        final edge = math.max(10.0, unit * 0.025);
        final floor = DashboardLayout.footprint(screen).height * 0.65;

        return Stack(
          children: [
            Positioned(
              right: pad.right + edge,
              bottom: floor,
              child: _Pedal(
                label: l10n.touchGas,
                width: pedalW,
                height: pedalH,
                accent: const Color(0xFF3DBB5A),
                icon: Icons.keyboard_double_arrow_up,
                ridges: _Ridges.bars,
                onChanged: onThrottle,
              ),
            ),
            Positioned(
              left: pad.left + edge,
              bottom: floor,
              child: _Pedal(
                label: l10n.touchBrake,
                width: pedalW,
                height: pedalH,
                accent: const Color(0xFFE5483A),
                icon: Icons.stop_circle_outlined,
                ridges: _Ridges.dots,
                onChanged: onBrake,
              ),
            ),
            if (showSteering)
              Positioned(
                left: pad.left + edge,
                bottom: floor + pedalH + edge,
                child: _SteerPad(
                  size: arrow,
                  gap: edge,
                  leftLabel: l10n.touchLeft,
                  rightLabel: l10n.touchRight,
                  onSteer: onSteer,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Hold extends StatefulWidget {
  const _Hold({required this.onChanged, required this.builder});

  final ValueChanged<bool> onChanged;
  final Widget Function(BuildContext context, bool down) builder;

  @override
  State<_Hold> createState() => _HoldState();
}

class _HoldState extends State<_Hold> {
  final Set<int> _pointers = {};
  bool _down = false;

  void _sync() {
    final next = _pointers.isNotEmpty;
    if (next == _down) return;
    setState(() => _down = next);
    if (next) HapticFeedback.selectionClick();
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (e) {
        _pointers.add(e.pointer);
        _sync();
      },
      onPointerUp: (e) {
        _pointers.remove(e.pointer);
        _sync();
      },
      onPointerCancel: (e) {
        _pointers.remove(e.pointer);
        _sync();
      },
      child: widget.builder(context, _down),
    );
  }
}

enum _Ridges { bars, dots }

class _Pedal extends StatelessWidget {
  const _Pedal({
    required this.label,
    required this.width,
    required this.height,
    required this.accent,
    required this.icon,
    required this.ridges,
    required this.onChanged,
  });

  final String label;
  final double width, height;
  final Color accent;
  final IconData icon;
  final _Ridges ridges;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: _Hold(
        onChanged: onChanged,
        builder: (context, down) => AnimatedScale(
          scale: down ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 70),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.22),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: down
                    ? [accent.withAlpha(235), accent.withAlpha(150)]
                    : const [Color(0xE64A4A55), Color(0xE622222A)],
              ),
              border: Border.all(
                color: down ? Colors.white : accent.withAlpha(200),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(140),
                  blurRadius: down ? 4 : 12,
                  offset: Offset(0, down ? 2 : 6),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _RidgePainter(ridges),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: width * 0.34),
                    SizedBox(
                      width: width * 0.86,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The grip texture of the pedal face.
class _RidgePainter extends CustomPainter {
  const _RidgePainter(this.kind);

  final _Ridges kind;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = math.max(1.5, size.width * 0.025)
      ..strokeCap = StrokeCap.round;
    if (kind == _Ridges.bars) {
      final x0 = size.width * 0.14, x1 = size.width * 0.86;
      for (var i = 1; i <= 6; i++) {
        final y = size.height * (0.1 + 0.14 * i);
        if (y > size.height * 0.94) break;
        canvas.drawLine(Offset(x0, y), Offset(x1, y), paint);
      }
    } else {
      final r = math.max(1.4, size.width * 0.02);
      for (var row = 0; row < 4; row++) {
        for (var col = 0; col < 7; col++) {
          canvas.drawCircle(
            Offset(
              size.width * (0.12 + 0.76 * col / 6),
              size.height * (0.12 + 0.76 * row / 3),
            ),
            r,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_RidgePainter old) => old.kind != kind;
}

class _SteerPad extends StatefulWidget {
  const _SteerPad({
    required this.size,
    required this.gap,
    required this.leftLabel,
    required this.rightLabel,
    required this.onSteer,
  });

  final double size, gap;
  final String leftLabel, rightLabel;
  final ValueChanged<double> onSteer;

  @override
  State<_SteerPad> createState() => _SteerPadState();
}

class _SteerPadState extends State<_SteerPad> {
  bool _left = false, _right = false;

  void _emit() =>
      widget.onSteer(((_right ? 1 : 0) - (_left ? 1 : 0)).toDouble());

  Widget _arrow(String label, IconData icon, ValueChanged<bool> set) {
    return Semantics(
      button: true,
      label: label,
      child: _Hold(
        onChanged: (v) {
          set(v);
          _emit();
        },
        builder: (context, down) => Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withAlpha(down ? 170 : 90),
            border: Border.all(
              color: down ? Colors.white : Colors.white54,
              width: 2.5,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: widget.size * 0.62),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _arrow(widget.leftLabel, Icons.chevron_left, (v) => _left = v),
        SizedBox(width: widget.gap),
        _arrow(widget.rightLabel, Icons.chevron_right, (v) => _right = v),
      ],
    );
  }
}
