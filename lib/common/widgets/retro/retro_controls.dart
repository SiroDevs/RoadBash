// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
// import '../../../core/audio/audio_catalog.dart';
// import '../../../core/audio/cubit/audio_cubit.dart';
import 'retro_style.dart';

// void _click(BuildContext context) => context.read<AudioCubit>().sfx(Sfx.click);

class RetroButton extends StatelessWidget {
  const RetroButton(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // _click(context);
        onTap();
      },
      style: FilledButton.styleFrom(
        backgroundColor: Retro.orange,
        foregroundColor: Retro.ink,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
    return InkWell(
      onTap: () {
        // _click(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment:
              center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(Icons.arrow_forward,
                size: 20, color: selected ? Retro.yellow : Colors.transparent),
            const SizedBox(width: 6),
            Text(label,
                style: retroBody(
                    size: 24, color: selected ? Colors.white : Retro.dim)),
          ],
        ),
      ),
    );
  }
}
