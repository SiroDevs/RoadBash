enum PropKind {
  building,
  broadleaf,
  pine,
  bush,
  lamp,
  sign,

  /// Spans the whole carriageway, so these are drawn by RoadSpanPainter.
  footbridge,
  gantry,
  overpass;

  bool get spansRoad =>
      this == footbridge || this == gantry || this == overpass;
}

/// One piece of roadside scenery, pinned to a segment for the whole race.
class Prop {
  const Prop({
    required this.kind,
    required this.anchor,
    required this.side,
    required this.offset,
    required this.width,
    required this.height,
    this.depth = 0,
    this.tint = 0,
    this.detail = 0,
  });

  final PropKind kind;

  /// Segment index the prop stands on.
  final int anchor;

  /// -1 for the left verge, 1 for the right.
  final int side;

  /// Distance from the road centre to the near face, in half-road-widths.
  final double offset;

  /// World units across (buildings) or half-width (billboards).
  final double width;

  /// World units tall.
  final double height;

  /// Segments the prop runs back along the road. 0 for billboards.
  final int depth;

  /// Palette slot for buildings, or the place name on a gantry.
  final int tint;

  /// Free parameter: window-grid density, canopy shape, sign face.
  final double detail;
}
