// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/audio/audio_catalog.dart';
import '../../../../core/audio/sound_player.dart';

/// Plays a music track while its child is shown.
class MusicScope extends StatefulWidget {
  const MusicScope({super.key, required this.track, required this.child});

  final MusicTrack track;
  final Widget child;

  @override
  State<MusicScope> createState() => _MusicScopeState();
}

/// State for [MusicScope]; starts and stops the music.
class _MusicScopeState extends State<MusicScope> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SoundPlayer>().playMusic(widget.track);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
