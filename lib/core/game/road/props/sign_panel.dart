enum SignArrow { none, up, exit }

class SignRow {
  const SignRow(this.text, {this.code, this.tail});

  final String text;
  final String? code;
  final String? tail;
}

class SignPanel {
  const SignPanel(
    this.rows, {
    this.side = const [],
    this.tab,
    this.footer,
    this.arrow = SignArrow.none,
    this.blue = false,
    this.weight = 1,
  });

  final List<SignRow> rows;
  final List<SignRow> side;
  final String? tab;
  final String? footer;
  final SignArrow arrow;
  final bool blue;
  final double weight;

  List<String> get texts => [for (final r in rows) r.text];
}

class SignBoard {
  const SignBoard(this.columns);

  final List<String> columns;
}
