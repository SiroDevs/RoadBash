// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/audio/audio_catalog.dart';

/// Audio state: the music track that is playing.
class AudioState extends Equatable {
  const AudioState({this.track});

  final MusicTrack? track;

  @override
  List<Object?> get props => [track];
}
