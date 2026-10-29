// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TouchHold extends StatefulWidget {
  const TouchHold({required this.onChanged, required this.builder});

  final ValueChanged<bool> onChanged;
  final Widget Function(BuildContext context, bool down) builder;

  @override
  State<TouchHold> createState() => TouchHoldState();
}

class TouchHoldState extends State<TouchHold> {
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
