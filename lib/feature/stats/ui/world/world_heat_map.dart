// Dart imports:
import 'dart:typed_data';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../domain/models/visitor_places.dart';
import 'heat_grid.dart';
import 'world_mask.dart';

/// A dot map of the world that glows where visitors come from.
class WorldHeatMap extends StatelessWidget {
  const WorldHeatMap({super.key, required this.places});

  final VisitorPlaces places;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: WorldMask.columns / WorldMask.rows,
    child: CustomPaint(painter: _WorldHeatPainter(HeatGrid.of(places))),
  );
}

/// Paints the land as dim dots and the visitors as glowing ones.
class _WorldHeatPainter extends CustomPainter {
  _WorldHeatPainter(this.grid);

  final HeatGrid grid;

  static const _land = Color(0x26FFFFFF);
  static const _cool = Color(0xFF6B3A1E);

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / WorldMask.columns;
    final cellH = size.height / WorldMask.rows;
    final dot = (cellW < cellH ? cellW : cellH) * 0.7;

    // Land
    final land = <double>[];
    for (var row = 0; row < WorldMask.rows; row++) {
      for (var column = 0; column < WorldMask.columns; column++) {
        if (!WorldMask.isLand(row, column)) continue;
        land
          ..add((column + 0.5) * cellW)
          ..add((row + 0.5) * cellH);
      }
    }
    canvas.drawRawPoints(
      PointMode.points,
      Float32List.fromList(land),
      Paint()
        ..color = _land
        ..strokeWidth = dot
        ..strokeCap = StrokeCap.round,
    );

    // Visitors
    final glow = Paint();
    final core = Paint();
    for (var row = 0; row < WorldMask.rows; row++) {
      for (var column = 0; column < WorldMask.columns; column++) {
        final heat = grid.cells[row][column];
        if (heat < 0.04) continue;
        final centre = Offset((column + 0.5) * cellW, (row + 0.5) * cellH);
        final color = _color(heat);
        canvas.drawCircle(centre, dot * (1.2 + 1.6 * heat), glow..color = color.withValues(alpha: 0.16 * heat));
        canvas.drawCircle(centre, dot * (0.45 + 0.4 * heat), core..color = color);
      }
    }
  }

  /// Returns the colour for a heat from 0 to 1: dark orange, orange, yellow.
  Color _color(double heat) => heat < 0.5
      ? Color.lerp(_cool, Retro.orange, heat * 2)!
      : Color.lerp(Retro.orange, Retro.yellow, (heat - 0.5) * 2)!;

  @override
  bool shouldRepaint(_WorldHeatPainter old) => old.grid != grid;
}
