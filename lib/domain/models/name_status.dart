/// Outcome of checking a player name.
enum NameCheck { invalid, available, taken, reservedOpen }

/// Name check result with an optional challenge question.
class NameStatus {
  const NameStatus(this.check, {this.name, this.question});

  final NameCheck check;
  final String? name;
  final String? question;
}
