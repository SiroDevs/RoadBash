// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../common/widgets/retro/retro_style.dart';

/// One labelled drawing in the pose lab.
class PoseCell extends StatelessWidget {
  const PoseCell({
    super.key,
    required this.label,
    required this.painter,
    this.size = const Size(120, 170),
  });

  final String label;
  final CustomPainter painter;
  final Size size;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        color: Retro.panel,
        child: CustomPaint(size: size, painter: painter),
      ),
      Text(label, style: retroBody(size: 12)),
    ],
  );
}

/// Draws with a callback, scaled so the design box fills the cell.
class PoseBoxPainter extends CustomPainter {
  const PoseBoxPainter({required this.draw, this.box = const Size(120, 170)});

  final void Function(Canvas canvas) draw;
  final Size box;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / box.height;
    canvas
      ..save()
      ..translate((size.width - box.width * scale) / 2, 0)
      ..scale(scale);
    draw(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(PoseBoxPainter old) => true;
}
