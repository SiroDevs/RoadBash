// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:roadbash/core/game/race/rival/rival_facing.dart';
import 'package:roadbash/core/game/race/rival/start_grid.dart';
import 'package:roadbash/core/game/rider/rig/player_yaw.dart';

void main() {
  group('RivalFacing', () {
    test('rivals on either side turn toward the player at the start', () {
      for (final side in [-0.8, -0.4, 0.4, 0.8]) {
        final yaw = RivalFacing.yaw(
          sideOffset: side,
          gap: 0,
          index: 0,
          atStart: true,
        );
        expect(yaw.sign, -side.sign);
        expect(yaw.abs(), lessThanOrEqualTo(RivalFacing.maxYaw));
      }
    });

    test('never faces away and eases to straight as the gap grows', () {
      var previous = double.infinity;
      for (var gap = 0.0; gap <= 400; gap += 20) {
        final yaw = RivalFacing.yaw(
          sideOffset: 0.4,
          gap: gap,
          index: 1,
          atStart: false,
        );
        expect(yaw, lessThanOrEqualTo(0));
        expect(yaw.abs(), lessThanOrEqualTo(previous));
        previous = yaw.abs();
      }
      expect(previous, 0);
    });
  });

  group('PlayerYaw', () {
    test('straights and slow riding show no yaw', () {
      expect(PlayerYaw.target(steer: 0, curve: 0, speedShare: 1), 0);
      expect(PlayerYaw.target(steer: 1, curve: 5, speedShare: 0.2), 0);
    });

    test('fast hard corners give a modest yaw, mirrored for left', () {
      final right = PlayerYaw.target(steer: 1, curve: 4, speedShare: 1);
      final left = PlayerYaw.target(steer: -1, curve: -4, speedShare: 1);
      expect(right, closeTo(PlayerYaw.maxYaw, 1e-9));
      expect(left, -right);
    });

    test('grows continuously with steering', () {
      var previous = 0.0;
      for (var steer = 0.0; steer <= 1; steer += 0.05) {
        final yaw = PlayerYaw.target(steer: steer, curve: 0, speedShare: 1);
        expect(yaw, greaterThanOrEqualTo(previous));
        previous = yaw;
      }
    });
  });

  test('StartGrid is symmetric around the centred player', () {
    final slots = [for (var i = 0; i < 4; i++) StartGrid.lateralFor(i, 4)];
    expect(slots.fold<double>(0, (sum, slot) => sum + slot), closeTo(0, 1e-9));
    expect(
      slots.every((slot) => slot.abs() <= StartGrid.outerLimit + 1e-9),
      isTrue,
    );
  });
}
