import 'dart:math' as math;
import 'dart:ui';

import 'look/rider_look.dart';
import 'view/part_painter.dart';

/// Ground-level rider and motorcycle artwork used between a wipeout and remount.
/// Coordinates match the rear rider sprite so it scales cleanly in the race.
class RecoveryPainter extends RiderPartPainter {
  RecoveryPainter(super.look);

  final Paint _p = Paint()..isAntiAlias = true;

  void paint(Canvas canvas, {required bool running, required double time, required double runX, required double fallSide}) {
    _drawBike(canvas, fallSide);
    if (running) {
      _drawRunner(canvas, runX, time);
    } else {
      _drawFallenRider(canvas, fallSide);
    }
  }

  void _drawBike(Canvas canvas, double side) {
    final y = groundY - 2;
    // Ground shadow and two foreshortened wheels.
    oval(canvas, Rect.fromCenter(center: Offset(midX, y), width: 74, height: 10), const Color(0x55000000));
    oval(canvas, Rect.fromCenter(center: Offset(midX - 23, y - 3), width: 18, height: 12), const Color(0xFF15171B));
    oval(canvas, Rect.fromCenter(center: Offset(midX + 23, y - 3), width: 18, height: 12), const Color(0xFF15171B));
    // Rear fairing, seat, tank and frame use the same palette as the riding bike.
    quad(canvas, bike.frame, [Offset(midX - 21, y - 13), Offset(midX - 9, y - 25), Offset(midX + 15, y - 25), Offset(midX + 27, y - 12), Offset(midX + 20, y - 8), Offset(midX - 17, y - 8)]);
    quad(canvas, bike.panelDark, [Offset(midX - 20, y - 15), Offset(midX - 14, y - 27), Offset(midX - 1, y - 24), Offset(midX - 5, y - 14)]);
    quad(canvas, bike.panel, [Offset(midX - 5, y - 23), Offset(midX + 10, y - 29), Offset(midX + 19, y - 17), Offset(midX + 11, y - 12), Offset(midX - 4, y - 14)]);
    quad(canvas, bike.accent, [Offset(midX - 21, y - 15), Offset(midX - 15, y - 25), Offset(midX - 12, y - 17)]);
    fill(canvas, Rect.fromLTWH(midX - 7, y - 31, 15, 5), bike.frame, 2);
    oval(canvas, Rect.fromCenter(center: Offset(midX, y - 11), width: 9, height: 7), bike.panelDark);
    oval(canvas, Rect.fromCenter(center: Offset(midX, y - 10), width: 4, height: 3), const Color(0xFF737985));
    final exhaust = Paint()..color = bike.trim..strokeWidth = 2.4..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(midX + 9, y - 10), Offset(midX + 28, y - 7), exhaust);
    oval(canvas, Rect.fromCenter(center: Offset(midX - 20, y - 15), width: 5, height: 3), bike.brakeLight);
    // Handlebar and mirror have a slight angle matching the wipeout direction.
    final bar = Paint()..color = bike.frame..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(midX + side * 9, y - 28), Offset(midX + side * 20, y - 34), bar);
    canvas.drawLine(Offset(midX + side * 20, y - 34), Offset(midX + side * 29, y - 32), bar);
    oval(canvas, Rect.fromCenter(center: Offset(midX + side * 25, y - 39), width: 5, height: 4), const Color(0xFFB7C1CC));
  }

  void _drawRunner(Canvas canvas, double runX, double time) {
    final x = midX + runX * 42;
    final phase = time * 10;
    final stride = math.sin(phase) * 8;
    final lift = math.max(0.0, math.cos(phase)) * 3;
    oval(canvas, Rect.fromCenter(center: Offset(x, groundY - lift), width: 22, height: 5), const Color(0x44000000));
    // Boots and legs, alternating at a readable running stride.
    limb(canvas, Offset(x - 2, groundY - 29 - lift), Offset(x - 8 + stride, groundY - 5 - lift), 7, look.boots);
    limb(canvas, Offset(x + 2, groundY - 29 - lift), Offset(x + 8 - stride, groundY - 5 - lift), 7, look.boots);
    limb(canvas, Offset(x - 2, groundY - 32 - lift), Offset(x - 8 + stride, groundY - 13 - lift), 9, look.suit);
    limb(canvas, Offset(x + 2, groundY - 32 - lift), Offset(x + 8 - stride, groundY - 13 - lift), 9, look.suit);
    // Padded jacket, back panel and shoulders.
    quad(canvas, look.suit, [Offset(x - 10, groundY - 68 - lift), Offset(x - 7, groundY - 78 - lift), Offset(x + 7, groundY - 78 - lift), Offset(x + 11, groundY - 67 - lift), Offset(x + 7, groundY - 39 - lift), Offset(x - 7, groundY - 39 - lift)]);
    quad(canvas, look.backPatch, [Offset(x - 5, groundY - 69 - lift), Offset(x + 5, groundY - 69 - lift), Offset(x + 4, groundY - 52 - lift), Offset(x - 4, groundY - 52 - lift)]);
    final trim = Paint()..color = look.stripeEdge..strokeWidth = 2.2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x - 8, groundY - 66 - lift), Offset(x - 4, groundY - 43 - lift), trim);
    canvas.drawLine(Offset(x + 8, groundY - 66 - lift), Offset(x + 4, groundY - 43 - lift), trim);
    // Arms pump opposite to the legs; gloves and helmet preserve the existing look.
    limb(canvas, Offset(x - 7, groundY - 71 - lift), Offset(x - 15 - stride * .35, groundY - 57 - lift), 7, look.suit);
    limb(canvas, Offset(x + 7, groundY - 71 - lift), Offset(x + 15 + stride * .35, groundY - 82 - lift), 7, look.suit);
    oval(canvas, Rect.fromCenter(center: Offset(x - 15 - stride * .35, groundY - 56 - lift), width: 7, height: 6), look.gloves);
    oval(canvas, Rect.fromCenter(center: Offset(x + 15 + stride * .35, groundY - 81 - lift), width: 7, height: 6), look.gloves);
    // Neck and helmet with a shaded lower edge and highlight.
    fill(canvas, Rect.fromLTWH(x - 4, groundY - 84 - lift, 8, 7), look.neck, 2);
    oval(canvas, Rect.fromCenter(center: Offset(x, groundY - 91 - lift), width: 18, height: 18), look.helmetShade);
    oval(canvas, Rect.fromLTWH(x - 8, groundY - 101 - lift, 15, 12), look.helmet);
    fill(canvas, Rect.fromLTWH(x + 2, groundY - 97 - lift, 10, 4), const Color(0xFF252A33), 2);
    oval(canvas, Rect.fromLTWH(x - 4, groundY - 100 - lift, 6, 2), const Color(0x99FFFFFF));
  }

  void _drawFallenRider(Canvas canvas, double side) {
    final x = midX + side * 34;
    oval(canvas, Rect.fromCenter(center: Offset(x, groundY - 1), width: 42, height: 7), const Color(0x44000000));
    // Side-lying posture: helmet, shoulder, bent legs, and one arm braced on road.
    oval(canvas, Rect.fromCenter(center: Offset(x - side * 16, groundY - 16), width: 20, height: 17), look.helmetShade);
    oval(canvas, Rect.fromCenter(center: Offset(x - side * 16, groundY - 20), width: 15, height: 12), look.helmet);
    limb(canvas, Offset(x - side * 8, groundY - 15), Offset(x + side * 12, groundY - 10), 17, look.suit);
    quad(canvas, look.backPatch, [Offset(x, groundY - 22), Offset(x + side * 12, groundY - 20), Offset(x + side * 14, groundY - 11), Offset(x + side * 2, groundY - 10)]);
    limb(canvas, Offset(x + side * 6, groundY - 13), Offset(x + side * 25, groundY - 3), 6, look.suit);
    limb(canvas, Offset(x + side * 3, groundY - 11), Offset(x - side * 8, groundY - 2), 7, look.suit);
    limb(canvas, Offset(x + side * 8, groundY - 17), Offset(x + side * 20, groundY - 27), 6, look.suit);
    oval(canvas, Rect.fromCenter(center: Offset(x + side * 21, groundY - 28), width: 7, height: 6), look.gloves);
  }
}
