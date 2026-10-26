// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../core/audio/audio_catalog.dart';
import '../../../constants/app_assets.dart';
import 'music_scope.dart';
import 'retro_scaffold.dart';

class RetroPage extends StatelessWidget {
  const RetroPage({
    super.key,
    required this.child,
    this.asset = AppAssets.appMain,
    this.track = MusicTrack.menu,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final String asset;
  final MusicTrack track;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => MusicScope(
    track: track,
    child: RetroScaffold(
      asset: asset,
      padding: padding,
      onTap: onTap,
      child: child,
    ),
  );
}
