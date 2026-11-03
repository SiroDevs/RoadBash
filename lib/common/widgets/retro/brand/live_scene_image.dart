// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../../../../core/game/common/preview/scene_snapshot.dart';
import '../../../../domain/models/scene_id.dart';
import '../feedback/retro_skeleton.dart';

/// A still of a scene drawn by the game itself, with a shimmering skeleton
/// while it is being drawn.
class LiveSceneImage extends StatefulWidget {
  const LiveSceneImage({super.key, required this.scene});

  final SceneId scene;

  @override
  State<LiveSceneImage> createState() => _LiveSceneImageState();
}

/// State for [LiveSceneImage]; loads the still for the current scene.
class _LiveSceneImageState extends State<LiveSceneImage> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _load();
    SceneSnapshot.warmUp(SceneId.values);
  }

  @override
  void didUpdateWidget(LiveSceneImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene != widget.scene) _load();
  }

  /// Takes the finished still, or waits for it to be drawn.
  void _load() {
    final scene = widget.scene;
    _image = SceneSnapshot.cached(scene);
    if (_image != null) return;
    SceneSnapshot.of(scene).then((image) {
      if (mounted && widget.scene == scene) setState(() => _image = image);
    }, onError: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) {
      return const RetroShimmer(child: RetroSkeletonBlock(height: double.infinity));
    }
    return RawImage(image: image, fit: BoxFit.cover);
  }
}
