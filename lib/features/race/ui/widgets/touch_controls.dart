// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart' show Vector2;

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../core/game/hud/dashboard_layout.dart';
import 'touch_pedal.dart';
import 'touch_steer_pad.dart';

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
              child: TouchPedal(
                label: l10n.touchGas,
                width: pedalW,
                height: pedalH,
                accent: const Color(0xFF3DBB5A),
                icon: Icons.keyboard_double_arrow_up,
                ridges: TouchRidges.bars,
                onChanged: onThrottle,
              ),
            ),
            Positioned(
              left: pad.left + edge,
              bottom: floor,
              child: TouchPedal(
                label: l10n.touchBrake,
                width: pedalW,
                height: pedalH,
                accent: const Color(0xFFE5483A),
                icon: Icons.stop_circle_outlined,
                ridges: TouchRidges.dots,
                onChanged: onBrake,
              ),
            ),
            if (showSteering)
              Positioned(
                left: pad.left + edge,
                bottom: floor + pedalH + edge,
                child: TouchSteerPad(
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
