/// Kinds of civilian vehicle that share the road with the racers.
enum CivilianKind {
  sedan(width: 1.0, tall: 0.80, length: 560),
  matatu(width: 1.12, tall: 1.20, length: 720),
  truck(width: 1.30, tall: 1.75, length: 950);

  const CivilianKind({
    required this.width,
    required this.tall,
    required this.length,
  });

  /// Painted width, in rider heights.
  final double width;

  /// Painted height, in rider heights.
  final double tall;

  /// Body length in road units, used for collisions.
  final double length;
}
