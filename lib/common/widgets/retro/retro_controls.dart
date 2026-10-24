// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/audio/audio_catalog.dart';
import '../../../core/audio/cubit/audio_cubit.dart';
import '../../layout/retro_sizes.dart';
import 'retro_style.dart';

void _click(BuildContext context) => context.read<AudioCubit>().sfx(Sfx.click);

class RetroButton extends StatelessWidget {
  const RetroButton(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    return FilledButton(
      onPressed: () {
        _click(context);
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

/// Menu row: a yellow arrow marks the selected entry.
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
        _click(context);
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
            // Shrinks long labels instead of overflowing a narrow cell.
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
