// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:roadbash/core/game/rider/art/sheet/art_ink.dart';
import 'package:roadbash/core/game/rider/art/sheet/rider_sheets.dart';
import 'package:roadbash/core/game/rider/look/rider_look.dart';
import 'package:roadbash/core/game/rider/rig/planted_leg.dart';

void main() {
  final sheet = InkedSheet.rider(RiderSheets.seated, RiderLook.main);

  for (final side in ['L', 'R']) {
    test('the $side leg put down bends the knee to 140 degrees', () {
      final leg = PlantedLeg(sheet, side);
      final hip = sheet.anchor('leg$side.hip');
      final knee = sheet.anchor('leg$side.knee');
      final ankle = sheet.anchor('leg$side.ankle') + leg.bootShift(1);
      final toHip = hip - knee;
      final toAnkle = ankle - knee;
      final cosine =
          (toHip.dx * toAnkle.dx + toHip.dy * toAnkle.dy) /
          (toHip.distance * toAnkle.distance);
      expect(math.acos(cosine) * 180 / math.pi, closeTo(140, 0.5));
      expect(ankle.dy, greaterThan(knee.dy));
    });

    test('the $side boot reaches the ground and stays seated at zero', () {
      final leg = PlantedLeg(sheet, side);
      expect(leg.bootShift(0), Offset.zero);
      final bottom = sheet
          .part('boot$side')
          .part
          .shapes
          .expand((shape) => shape.points)
          .map((point) => point.dy)
          .reduce(math.max);
      expect(bottom + leg.bootShift(1).dy, closeTo(PlantedLeg.groundY, 0.01));
    });
  }
}
