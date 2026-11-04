// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/stats_models.dart';
import '../../cubit/stats_cubit.dart';

/// Heatmap of activity by day and hour.
class RetroHeatmap extends StatelessWidget {
  const RetroHeatmap({
    super.key,
    required this.cells,
    required this.metric,
    required this.dayLabels,
  });

  final List<HeatCell> cells;
  final HeatMetric metric;
  final List<String> dayLabels;

  @override
  Widget build(BuildContext context) {
    final sizes = context.sizes;
    final grid = List<int>.filled(7 * 24, 0);
    for (final c in cells) {
      final count = metric == HeatMetric.visitors ? c.visitors : c.players;
      grid[(c.day - 1) * 24 + c.hour] = count;
    }
    final peak = grid.reduce(math.max);
    return LayoutBuilder(
      builder: (context, box) {
        const labelW = 26.0;
        final cell = (box.maxWidth - labelW) / 24;
        return CustomPaint(
          size: Size(box.maxWidth, cell * 7 + 18),
          painter: _HeatPainter(
            grid: grid,
            peak: peak,
            labels: dayLabels,
            labelW: labelW,
            fontSize: sizes.caption * 0.7,
          ),
        );
      },
    );
  }
}

/// Paints the heatmap cells and labels.
class _HeatPainter extends CustomPainter {
  _HeatPainter({
    required this.grid,
    required this.peak,
    required this.labels,
    required this.labelW,
    required this.fontSize,
  });

  final List<int> grid;
  final int peak;
  final List<String> labels;
  final double labelW;
  final double fontSize;

  static const _low = Color(0xFF6B3A1E);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = (size.width - labelW) / 24;
    for (var d = 0; d < 7; d++) {
      _text(canvas, labels[d], Offset(0, d * cell + (cell - fontSize) / 2));
      for (var h = 0; h < 24; h++) {
        final count = grid[d * 24 + h];
        final paint = Paint()
          ..color = count == 0
              ? const Color(0x22FFFFFF)
              : Color.lerp(_low, Retro.yellow, count / peak)!;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(labelW + h * cell + 0.5, d * cell + 0.5, cell - 1, cell - 1),
            const Radius.circular(2),
          ),
          paint,
        );
      }
    }
    for (final h in [0, 6, 12, 18, 23]) {
      _text(canvas, '$h', Offset(labelW + h * cell, cell * 7 + 3));
    }
  }

  /// Draws a text label at the given position.
  void _text(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Retro.dim, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_HeatPainter old) =>
      old.peak != peak || old.grid != grid || old.labels != labels;
}
