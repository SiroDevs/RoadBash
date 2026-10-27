enum SignArrow { none, up, exit, upLeft }

class SignRow {
  const SignRow(this.text, {this.code, this.tail});

  final String text;
  final String? code;
  final String? tail;
}

const List<SignRow> _exitRows = [SignRow('EXIT'), SignRow('KUTOKA')];

class SignPanel {
  const SignPanel(
    this.rows, {
    this.side = const [],
    this.tab,
    this.footer,
    this.arrow = SignArrow.none,
    this.blue = false,
    this.weight = 1,
    this.roundel,
    this.aspect,
    this.framed = false,
  });

  final List<SignRow> rows;
  final List<SignRow> side;
  final String? tab;
  final String? footer;
  final SignArrow arrow;
  final bool blue;
  final double weight;

  /// Blue numbered exit board: up-left arrow, "EXIT / KUTOKA" and the exit
  /// number in a white disc. Only the number changes between exits.
  const SignPanel.numbered(String number)
    : this(
        _exitRows,
        arrow: SignArrow.upLeft,
        roundel: number,
        aspect: 2.45,
        framed: true,
      );

  /// Green named exit board: up-left arrow, then a destination per row with
  /// an optional road code in amber, e.g. `SignRow('Thika', code: '(G 3203)')`.
  const SignPanel.named(List<SignRow> rows)
    : this(rows, arrow: SignArrow.upLeft, aspect: 3.1, framed: true);

  /// Number shown in a white disc on the right of the board (e.g. exit "17").
  final String? roundel;

  /// Board width / height. When set, the board is drawn at this shape
  /// instead of the default tall panel.
  final double? aspect;

  /// Draws a thin white rim around the board.
  final bool framed;

  List<String> get texts => [for (final r in rows) r.text];
}

class SignBoard {
  const SignBoard(this.columns);

  final List<String> columns;
}
