// Flutter imports:
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'audio_catalog.dart';
import 'cubit/audio_cubit.dart';

/// Starts [track] when this part of the app appears (no-op if already playing).
class MusicScope extends StatefulWidget {
  const MusicScope({super.key, required this.track, required this.child});

  final MusicTrack track;
  final Widget child;

  @override
  State<MusicScope> createState() => _MusicScopeState();
}

class _MusicScopeState extends State<MusicScope> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AudioCubit>().playMusic(widget.track);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
