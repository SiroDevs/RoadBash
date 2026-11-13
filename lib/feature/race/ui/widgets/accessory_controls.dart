// Flutter imports:
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/constants/app_constants.dart';
import '../../../../core/game/road_game.dart';
import '../../../../l10n/l10n_extension.dart';

/// Portrait race controls for boost, attacks, and available item slots.
class AccessoryControls extends StatelessWidget {
  const AccessoryControls({
    super.key,
    required this.game,
    required this.portrait,
  });

  final RoadGame game;
  final bool portrait;

  /// Enables race accessories only while the moving race is active.
  bool get _canUse =>
      game.isLoaded &&
      !game.menuPaused &&
      game.race.running &&
      !game.road.stopped &&
      !game.road.crashed &&
      !game.road.recovering;

  void _setBoost(bool pressed) {
    game.setBoost(pressed && _canUse);
  }

  /// Sends an attack press through the existing hit system.
  void _setAttack(bool pressed) {
    game.setAttack(pressed && _canUse && game.rules.combat);
  }

  /// Builds the active accessory row.
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StreamBuilder<bool>(
      stream: Stream<bool>.periodic(
        const Duration(milliseconds: 120),
        (_) => _canUse,
      ).distinct(),
      initialData: _canUse,
      builder: (context, snapshot) {
        final active = snapshot.data ?? false;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: portrait ? 8 : 5,
            vertical: portrait ? 8 : 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: _AccessoryButton(
                  label: l10n.hudBoostLabel,
                  semanticsLabel: l10n.hudBoostLabel,
                  icon: Icons.bolt,
                  enabled: active,
                  onHold: _setBoost,
                ),
              ),
              Expanded(
                child: _AccessoryButton(
                  label: l10n.hudAttackLabel,
                  semanticsLabel: l10n.hudAttackLabel,
                  icon: Icons.sports_martial_arts,
                  enabled: active && game.rules.combat,
                  onHold: _setAttack,
                ),
              ),
              for (var slot = 1; slot <= 3; slot++)
                Expanded(
                  child: _AccessoryButton(
                    label: l10n.hudItemLabel,
                    semanticsLabel: l10n.hudItemSlot(slot),
                    icon: Icons.inventory_2_outlined,
                    enabled: false,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A square, high-contrast accessory control with a localized label.
class _AccessoryButton extends StatelessWidget {
  const _AccessoryButton({
    required this.label,
    required this.semanticsLabel,
    required this.icon,
    required this.enabled,
    this.onHold,
  });

  final String label;
  final String semanticsLabel;
  final IconData icon;
  final bool enabled;
  final ValueChanged<bool>? onHold;

  /// Builds one touch target for an accessory.
  @override
  Widget build(BuildContext context) {
    final ink = enabled ? const Color(0xFFF4F0E6) : const Color(0xFF68686D);
    final fill = enabled ? const Color(0xFF202127) : const Color(0xFF101115);
    final border = enabled ? const Color(0xFF666873) : const Color(0xFF303137);
    return LayoutBuilder(
      builder: (context, constraints) {
        final iconSize = math.min(17.0, constraints.maxHeight * 0.48);
        final textSize = math.min(10.0, constraints.maxHeight * 0.28);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Semantics(
            button: true,
            enabled: enabled,
            label: semanticsLabel,
            onTap: enabled && onHold != null
                ? () {
                    onHold!(true);
                    Timer(const Duration(milliseconds: 150), () {
                      onHold!(false);
                    });
                  }
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: enabled && onHold != null
                  ? (_) => onHold!(true)
                  : null,
              onTapUp: enabled && onHold != null ? (_) => onHold!(false) : null,
              onTapCancel: enabled && onHold != null
                  ? () => onHold!(false)
                  : null,
              child: Container(
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: fill,
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: iconSize, color: ink),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        label.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ink,
                          fontFamily: AppConstants.displayFont,
                          fontSize: textSize,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
