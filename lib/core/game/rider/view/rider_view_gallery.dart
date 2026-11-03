// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import '../look/rider_look.dart';
import '../rider_sprite.dart';
import 'rider_view.dart';

/// Shows the rider and bike from all four views side by side. A working aid
/// while drawing the views: put it on any screen to see them all at once.
class RiderViewGallery extends StatefulWidget {
  const RiderViewGallery({super.key, this.look = RiderLook.main, this.speed = 0.5});

  final RiderLook look;
  final double speed;

  @override
  State<RiderViewGallery> createState() => _RiderViewGalleryState();
}

/// State for [RiderViewGallery]; holds one sprite per view.
class _RiderViewGalleryState extends State<RiderViewGallery> {
  late final List<RiderSprite> _sprites = [
    for (final view in RiderView.values)
      RiderSprite(look: widget.look, view: view)..pose.speed = widget.speed,
  ];

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final sprite in _sprites)
        Expanded(
          flex: sprite.view.canvas.width.round(),
          child: AspectRatio(
            aspectRatio: sprite.view.canvas.width / sprite.view.canvas.height,
            child: CustomPaint(painter: RiderSpritePainter(sprite)),
          ),
        ),
    ],
  );
}
