// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../l10n/l10n_extension.dart';

/// On-screen steering arrows (left) and gas / brake pedals (right).
class TouchControls extends StatelessWidget {
  const TouchControls({
    super.key,
    required this.onSteer,
    required this.onThrottle,
    required this.onBrake,
  });

  final ValueChanged<double> onSteer;
  final ValueChanged<bool> onThrottle;
  final ValueChanged<bool> onBrake;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _HoldButton(l10n.touchLeft, Icons.chevron_left, (d) => onSteer(d ? -1 : 0)),
            const SizedBox(width: 12),
            _HoldButton(l10n.touchRight, Icons.chevron_right, (d) => onSteer(d ? 1 : 0)),
            const Spacer(),
            _HoldButton(l10n.touchBrake, Icons.pan_tool_alt, onBrake),
            const SizedBox(width: 12),
            _HoldButton(l10n.touchGas, Icons.keyboard_double_arrow_up, onThrottle, size: 88),
          ],
        ),
      ),
    );
  }
}

class _HoldButton extends StatefulWidget {
  const _HoldButton(this.label, this.icon, this.onChanged, {this.size = 68});

  final String label;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  State<_HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<_HoldButton> {
  bool _down = false;

  void _set(bool v) {
    if (_down == v) return;
    setState(() => _down = v);
    widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      child: Listener(
        onPointerDown: (_) => _set(true),
        onPointerUp: (_) => _set(false),
        onPointerCancel: (_) => _set(false),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withAlpha(_down ? 140 : 70),
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: Icon(widget.icon, color: Colors.white70, size: widget.size * 0.55),
        ),
      ),
    );
  }
}
