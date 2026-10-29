// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reports whether any pointer is pressing its child.
class TouchHold extends StatefulWidget {
  const TouchHold({required this.onChanged, required this.builder});

  final ValueChanged<bool> onChanged;
  final Widget Function(BuildContext context, bool down) builder;

  @override
  State<TouchHold> createState() => TouchHoldState();
}

/// State for [TouchHold]; tracks active pointers.
class TouchHoldState extends State<TouchHold> {
  final Set<int> _pointers = {};
  bool _down = false;

  /// Notifies the listener when the pressed state changes.
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
