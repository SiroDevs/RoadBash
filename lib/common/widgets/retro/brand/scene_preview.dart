// Flutter imports:
import 'package:flutter/material.dart';

/// Shows a scene's preview image.
class ScenePreview extends StatelessWidget {
  const ScenePreview(this.sceneImg, {super.key});

  final String sceneImg;

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
          child: Image.asset(sceneImg, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
