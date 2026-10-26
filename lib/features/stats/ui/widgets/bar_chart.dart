// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';

class RetroBarChart extends StatelessWidget {
  const RetroBarChart({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
    this.color = Retro.orange,
  });

  final String title;
  final List<int> values;
  final List<String> labels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final s = context.sizes;
    final peak = values.isEmpty ? 0 : values.reduce(math.max);
    final caption = retroBody(size: s.caption, color: Retro.dim);
    final marks = labels.isEmpty
        ? const <String>[]
        : [labels.first, labels[labels.length ~/ 2], labels.last];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: retroBody(size: s.small, color: color)),
            Text('max $peak', style: caption),
          ],
        ),
        SizedBox(height: s.gapSmall),
        SizedBox(
          width: double.infinity,
          height: s.gap * 8,
          child: CustomPaint(painter: _BarPainter(values, color)),
        ),
        SizedBox(height: s.gapSmall * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [for (final m in marks) Text(m, style: caption)],
        ),
      ],
    )
        .padding(all: s.gap)
        .decorated(color: Retro.panel, borderRadius: BorderRadius.circular(12));
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.values, this.color);

  final List<int> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final peak = math.max(1, values.reduce(math.max));
    final gap = values.length > 40 ? 1.0 : 3.0;
    final width = (size.width - gap * (values.length - 1)) / values.length;
    final paint = Paint()..color = color;
    final faint = Paint()..color = Retro.dim.withValues(alpha: 0.35);
    for (var i = 0; i < values.length; i++) {
      final x = i * (width + gap);
      final h = values[i] == 0
          ? 2.0
          : math.max(3.0, values[i] / peak * (size.height - 2));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, width, h),
          const Radius.circular(2),
        ),
        values[i] == 0 ? faint : paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.color != color || !listEquals(old.values, values);
}
