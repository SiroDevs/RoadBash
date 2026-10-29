// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'touch_hold.dart';

/// Left and right steering buttons.
class TouchSteerPad extends StatefulWidget {
  const TouchSteerPad({
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
  State<TouchSteerPad> createState() => TouchSteerPadState();
}

/// State for [TouchSteerPad]; tracks which side is pressed.
class TouchSteerPadState extends State<TouchSteerPad> {
  bool _left = false, _right = false;

  /// Reports the combined steering value, from -1 to 1.
  void _emit() =>
      widget.onSteer(((_right ? 1 : 0) - (_left ? 1 : 0)).toDouble());

  /// Builds one accessible steering arrow button.
  Widget _arrow(String label, IconData icon, ValueChanged<bool> set) {
    return Semantics(
      button: true,
      label: label,
      child: TouchHold(
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
