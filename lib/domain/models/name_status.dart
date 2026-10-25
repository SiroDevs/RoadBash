enum NameCheck { invalid, available, taken, reservedOpen }

class NameStatus {
  const NameStatus(this.check, {this.name, this.question});

  factory NameStatus.fromJson(Map<String, dynamic> json) => NameStatus(
    switch (json['status']) {
      'available' => NameCheck.available,
      'taken' => NameCheck.taken,
      'reserved_open' => NameCheck.reservedOpen,
      _ => NameCheck.invalid,
    },
    name: json['name'] as String?,
    question: json['question'] as String?,
  );

  final NameCheck check;
  final String? name;
  final String? question;
}
