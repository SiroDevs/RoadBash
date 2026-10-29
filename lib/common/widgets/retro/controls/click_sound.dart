// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../core/audio/audio_catalog.dart';
import '../../../../core/audio/sound_player.dart';

/// Plays the click sound.
void playClick(BuildContext context) =>
    context.read<SoundPlayer>().sfx(Sfx.click);
