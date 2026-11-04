// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../../../l10n/l10n_extension.dart';
import '../../../../core/game/hud/handlebar_layout.dart';
import '../../../../core/game/input/handlebar_pose.dart';

/// Invisible touch layer that grabs and drags the handlebars drawn by the game.
class HandlebarPad extends StatefulWidget {
  const HandlebarPad({super.key, required this.onChanged});

  final ValueChanged<HandlebarPose> onChanged;

  @override
  State<HandlebarPad> createState() => _HandlebarPadState();
}

/// Where a pointer grabbed a bar.
class _Grab {
  const _Grab(this.side, this.startY);

  final HandlebarSide side;
  final double startY;
}

/// State for [HandlebarPad]; tracks one pointer per bar.
class _HandlebarPadState extends State<HandlebarPad> {
  final Map<int, _Grab> _grabs = {};
  final Map<HandlebarSide, double> _offsets = {};
  HandlebarLayout? _layout;

  /// Reports the current pose of both bars.
  void _emit() {
    widget.onChanged(
      HandlebarPose(
        leftHeld: _offsets.containsKey(HandlebarSide.left),
        rightHeld: _offsets.containsKey(HandlebarSide.right),
        leftOffset: _offsets[HandlebarSide.left] ?? 0,
        rightOffset: _offsets[HandlebarSide.right] ?? 0,
      ),
    );
  }

  /// Grabs the bar under a new pointer, if that bar is free.
  void _grab(PointerDownEvent event) {
    final layout = _layout;
    if (layout == null) return;
    for (final side in HandlebarSide.values) {
      if (_offsets.containsKey(side)) continue;
      if (!layout.zone(side).contains(event.localPosition)) continue;
      _grabs[event.pointer] = _Grab(side, event.localPosition.dy);
      _offsets[side] = 0;
      HapticFeedback.selectionClick();
      _emit();
      return;
    }
  }

  /// Moves a grabbed bar up or down with its pointer.
  void _drag(PointerMoveEvent event) {
    final grab = _grabs[event.pointer];
    final layout = _layout;
    if (grab == null || layout == null) return;
    final pulled = (event.localPosition.dy - grab.startY) / layout.travel;
    _offsets[grab.side] = pulled.clamp(-1.0, 1.0).toDouble();
    _emit();
  }

  /// Lets go of the bar a pointer was holding.
  void _release(PointerEvent event) {
    final grab = _grabs.remove(event.pointer);
    if (grab == null) return;
    _offsets.remove(grab.side);
    _emit();
  }

  /// Builds the screen reader label for one bar.
  Widget _label(HandlebarLayout layout, HandlebarSide side, String text) {
    return Positioned.fromRect(
      rect: layout.zone(side),
      child: Semantics(
        container: true,
        label: text,
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, box) {
        final layout = HandlebarLayout(Vector2(box.maxWidth, box.maxHeight));
        _layout = layout;
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _grab,
          onPointerMove: _drag,
          onPointerUp: _release,
          onPointerCancel: _release,
          child: Stack(
            children: [
              _label(layout, HandlebarSide.left, l10n.handlebarLeft),
              _label(layout, HandlebarSide.right, l10n.handlebarRight),
            ],
          ),
        );
      },
    );
  }
}
