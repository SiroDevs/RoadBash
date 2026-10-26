enum VergeKind { dirt, grass, paved }

enum MedianKind { guardrail, planted, barrier, none }

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

  bool get hasOpposite => median != MedianKind.none;

  static const Section plain = Section();
}
