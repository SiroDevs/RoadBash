// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../common/constants/app_assets.dart';
import '../../../common/layout/retro_sizes.dart';
import '../../../common/widgets/retro/page/retro_scaffold.dart';
import '../../../common/widgets/retro/page/retro_sub_page.dart';
import '../../../common/widgets/retro/retro_style.dart';
import '../../../core/game/rider/look/rider_look.dart';
import '../../../core/game/rider/rider_sprite.dart';
import '../../../core/game/rider/rig/rider_on_foot.dart';
import '../../../core/router/route_names.dart';
import '../../../l10n/l10n_extension.dart';
import 'pose_cell.dart';

/// Debug screen showing every rider pose side by side, one tap from the menu.
class PoseLabScreen extends StatelessWidget {
  const PoseLabScreen({super.key});

  static const List<double> yaws = [-1, -0.7, -0.35, 0, 0.35, 0.7, 1];
  static const List<double> runCycles = [0, 0.25, 0.5, 0.75];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onFoot = RiderOnFoot(RiderLook.main);
    return RetroScaffold(
      asset: AppAssets.appMain,
      dim: 0.4,
      child: SingleChildScrollView(
        child: RetroSubPage(
          title: l10n.poseLabTitle,
          onBack: () => context.goNamed(RouteNames.menu),
          maxWidth: 1100,
          children: [
            _heading(l10n.poseLabYawSection),
            _wrap([
              for (final foot in [0.0, 1.0])
                for (final yaw in yaws)
                  PoseCell(
                    label:
                        '${yaw.toStringAsFixed(2)} · '
                        '${foot > 0 ? l10n.poseLabFootDown : l10n.poseLabFootUp}',
                    painter: _seated(yaw, foot),
                  ),
            ]),
            SizedBox(height: context.sizes.gap),
            _heading(l10n.poseLabOnFootSection),
            _wrap([
              for (final cycle in runCycles)
                _foot(
                  '${l10n.poseLabRunning} $cycle',
                  (canvas) => onFoot.paintRunning(canvas, cycle),
                ),
              _foot(
                l10n.poseLabThrown,
                (canvas) => onFoot.paintThrown(canvas, 0.5),
              ),
              _foot(
                l10n.poseLabGettingUp,
                (canvas) => onFoot.paintGettingUp(canvas, 0.5),
              ),
              _foot(
                l10n.poseLabMounting,
                (canvas) => onFoot.paintMounting(canvas, 0.3),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: retroBody(size: 18)),
  );

  Widget _wrap(List<Widget> cells) =>
      Wrap(spacing: 8, runSpacing: 8, children: cells);

  Widget _foot(String label, void Function(Canvas canvas) draw) => PoseCell(
    label: label,
    painter: PoseBoxPainter(draw: draw),
  );

  /// Seated rider and bike at a fixed yaw and foot state.
  CustomPainter _seated(double yaw, double foot) {
    final sprite = RiderSprite(useSuppliedArt: true);
    sprite.pose
      ..perspective = yaw
      ..foot = foot;
    return PoseBoxPainter(draw: sprite.paint);
  }
}
