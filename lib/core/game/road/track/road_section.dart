/// Kinds of road verge.
enum VergeKind { dirt, grass, paved }

/// Kinds of road median.
enum MedianKind { guardrail, planted, barrier, none }

/// Verge and median layout of one road segment.
class Section {
  const Section({
    this.left = VergeKind.dirt,
    this.right = VergeKind.grass,
    this.median = MedianKind.guardrail,
    this.railLeft = false,
  });

  final VergeKind left;
  final VergeKind right;
  final MedianKind median;
  final bool railLeft;

  /// True when the section has an opposite carriageway.
  bool get hasOpposite => median != MedianKind.none;

  static const Section plain = Section();
}
