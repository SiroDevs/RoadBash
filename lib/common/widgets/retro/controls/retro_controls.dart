// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../layout/retro_sizes.dart';
import 'click_sound.dart';
import '../retro_style.dart';

class RetroButton extends StatelessWidget {
  const RetroButton(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return FilledButton(
      onPressed: () {
        playClick(context);
        onTap();
      },
      style: FilledButton.styleFrom(
        backgroundColor: Retro.orange,
        foregroundColor: Retro.ink,
        padding: EdgeInsets.symmetric(horizontal: s.buttonH, vertical: s.buttonV),
        textStyle: TextStyle(fontSize: s.buttonText, fontWeight: FontWeight.w700),
      ),
      child: Text(label.toUpperCase()),
    );
  }
}

class RetroMenuItem extends StatelessWidget {
  const RetroMenuItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.center = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return InkWell(
      onTap: () {
        playClick(context);
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: s.menuItemV),
        child: Row(
          mainAxisAlignment:
              center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              Icons.arrow_forward,
              size: s.icon,
              color: selected ? Retro.yellow : Colors.transparent,
            ),
            SizedBox(width: s.gapSmall * 0.75),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: retroBody(
                    size: s.body,
                    color: selected ? Colors.white : Retro.dim,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
