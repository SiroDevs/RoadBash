// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../constants/app_constants.dart';

/// The game wordmark: two stamped plates split by a bolt.
class RoadBashLogo extends StatelessWidget {
  const RoadBashLogo({super.key, this.size = 64});

  final double size;

  Widget _plate(String text, Color bg, Color fg) => Container(
        padding: EdgeInsets.symmetric(horizontal: size * 0.25, vertical: size * 0.08),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: Colors.black, width: size * 0.06),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: size,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            height: 1,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = AppConstants.appTitle.toUpperCase();
    final cut = title.length >= 8 ? 4 : title.length ~/ 2;
    return Transform(
      transform: Matrix4.skewX(-0.12),
      alignment: Alignment.center,
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _plate(title.substring(0, cut), Colors.black, const Color(0xFFE53935)),
            Icon(Icons.bolt, size: size * 1.1, color: const Color(0xFFFFC857)),
            _plate(title.substring(cut), const Color(0xFFE53935), Colors.black),
          ],
        ),
      ),
    );
  }
}
