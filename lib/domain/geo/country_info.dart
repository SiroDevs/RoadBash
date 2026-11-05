/// A country: its two-letter code, English name and a point near its centre.
class CountryInfo {
  const CountryInfo(this.code, this.name, this.latitude, this.longitude);

  final String code;
  final String name;
  final double latitude;
  final double longitude;

  /// The country's flag as an emoji, built from its code.
  String get flag => flagOf(code);

  /// Returns the flag emoji for a two-letter country [code], or an empty text.
  static String flagOf(String code) {
    if (code.length != 2) return '';
    final letters = code.toUpperCase().codeUnits;
    if (letters.any((unit) => unit < 65 || unit > 90)) return '';
    return String.fromCharCodes([for (final unit in letters) 0x1F1E6 + unit - 65]);
  }
}
