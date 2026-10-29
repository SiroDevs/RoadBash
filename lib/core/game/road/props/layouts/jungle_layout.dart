// Project imports:
import '../../../utils/pseudo_random.dart';
import '../prop.dart';

/// Dense tropical growth: a close row of big trees and palms hugging the
/// road, a second row behind them and ferns in the gaps.
void layOutJungle(List<List<Prop>> slots, int count) {
  for (final side in const [-1, 1]) {
    _row(slots, count, side, start: side < 0 ? 1 : 3, near: true);
    _row(slots, count, side, start: side < 0 ? 4 : 2, near: false);
  }

  for (var i = 30; i < count - 2; i += 83) {
    slots[i].add(Prop(
      kind: PropKind.sign,
      anchor: i,
      side: -1,
      offset: 1.3,
      width: 260,
      height: 1050,
      detail: pseudoRandom(i + 2),
    ));
  }
}

/// Places a row of jungle trees along one side.
void _row(
  List<List<Prop>> slots,
  int count,
  int side, {
  required int start,
  required bool near,
}) {
  var cursor = start;
  while (cursor < count - 2) {
    final seed = (cursor * 2 + (side > 0 ? 1 : 0)) * (near ? 23 : 41) + 9;
    final roll = pseudoRandom(seed);
    final PropKind kind;
    if (near) {
      kind = roll < 0.38
          ? PropKind.broadleaf
          : (roll < 0.66 ? PropKind.palm : PropKind.bush);
    } else {
      kind = roll < 0.55 ? PropKind.broadleaf : PropKind.palm;
    }
    final scale = kind == PropKind.bush
        ? 0.6 + 0.4 * pseudoRandom(seed + 2)
        : 0.9 + 0.7 * pseudoRandom(seed + 2);
    final base = switch (kind) {
      PropKind.broadleaf => 3600.0,
      PropKind.palm => 3900.0,
      _ => 1500.0,
    };
    slots[cursor].add(Prop(
      kind: kind,
      anchor: cursor,
      side: side,
      offset: near
          ? 1.55 + 0.9 * pseudoRandom(seed + 1)
          : 2.7 + 2.6 * pseudoRandom(seed + 1),
      width: (kind == PropKind.bush ? 640 : 900) * scale,
      height: base * scale,
      detail: pseudoRandom(seed + 3),
    ));
    cursor += (near ? 3 : 4) + (pseudoRandom(seed + 4) * (near ? 5 : 6)).floor();
  }
}
