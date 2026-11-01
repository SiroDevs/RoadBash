// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../domain/models/scene_id.dart';
import 'live_scene_image.dart';

/// Shows a scene's preview: a still drawn by the game for a scene, or an
/// image asset for the reception.
class ScenePreview extends StatelessWidget {
  const ScenePreview({super.key, this.sceneImg, this.scene});

  final String? sceneImg;
  final SceneId? scene;

  @override
  Widget build(BuildContext context) {
    
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFEDEDED),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: scene != null
              ? LiveSceneImage(scene: scene!)
              : Image.asset(sceneImg!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
