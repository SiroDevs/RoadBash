// Project imports:
import '../../utils/pseudo_random.dart';
import '../universal/prop.dart';

/// Places a row of jungle trees along one side.
void layJungleRow(
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
