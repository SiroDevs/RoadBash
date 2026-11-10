// Flutter imports:
import 'package:flutter/material.dart';

/// On-screen button that bashes a nearby rival while it is held.
class AttackButton extends StatelessWidget {
  const AttackButton({super.key, required this.onHold});

  final ValueChanged<bool> onHold;

  @override
  Widget build(BuildContext context) => Positioned(
    right: 24,
    bottom: 112,
    child: GestureDetector(
      onTapDown: (_) => onHold(true),
      onTapUp: (_) => onHold(false),
      onTapCancel: () => onHold(false),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xCC8E241D),
          border: Border.all(color: Colors.white70, width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: const SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: Text(
              'HIT',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
  );
}
