// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../audio_catalog.dart';

class AudioState extends Equatable {
  const AudioState({this.track});

  final MusicTrack? track;

  @override
  List<Object?> get props => [track];
}
