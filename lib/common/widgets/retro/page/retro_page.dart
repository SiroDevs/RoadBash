// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../core/audio/audio_catalog.dart';
import '../../../constants/app_assets.dart';
import 'music_scope.dart';
import 'retro_scaffold.dart';

/// Retro page that adds the backdrop and plays an optional music track.
class RetroPage extends StatelessWidget {
  const RetroPage({
    super.key,
    required this.child,
    this.asset = AppAssets.appMain,
    this.grayscale = false,
    this.dim = 0,
    this.track = MusicTrack.menu,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final String asset;
  final bool grayscale;
  final double dim;
  final MusicTrack track;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => MusicScope(
    track: track,
    child: RetroScaffold(
      asset: asset,
      grayscale: grayscale,
      dim: dim,
      padding: padding,
      onTap: onTap,
      child: child,
    ),
  );
}