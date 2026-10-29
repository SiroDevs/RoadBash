// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../features/settings/cubit/settings_cubit.dart';
import '../di/injectable.dart';
import 'synth/engine_synth.dart';

/// Starts the engine-sound machinery on the player's first tap, in the
/// background, while they are still on the splash or menu screens. Without it
/// all of that work lands on the first frames of the race, which on a phone
/// browser shows up as a rough start.
class AudioWarmUp extends StatefulWidget {
  const AudioWarmUp({super.key, required this.child});

  final Widget child;

  @override
  State<AudioWarmUp> createState() => _AudioWarmUpState();
}

/// State for [AudioWarmUp]; prepares the engine sound once.
class _AudioWarmUpState extends State<AudioWarmUp> {
  bool _done = false;

  /// Prepares the engine synth in advance.
  void _warm() {
    if (_done) return;
    _done = true;
    EngineSynth.warmUp(getIt<SettingsCubit>().state.profile.flavour);
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerUp: (_) => _warm(),
    child: widget.child,
  );
}
