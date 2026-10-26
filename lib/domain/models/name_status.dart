enum NameCheck { invalid, available, taken, reservedOpen }

class NameStatus {
  const NameStatus(this.check, {this.name, this.question});

  final NameCheck check;
  final String? name;
  final String? question;
}
