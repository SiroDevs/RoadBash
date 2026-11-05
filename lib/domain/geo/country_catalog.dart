// Project imports:
import 'countries_first.dart';
import 'countries_second.dart';
import 'country_info.dart';

/// Looks countries up by their two-letter code.
abstract final class CountryCatalog {
  static final Map<String, CountryInfo> _byCode = {
    for (final country in [...countriesFirst, ...countriesSecond])
      country.code: country,
  };

  /// Returns the country for [code], or null when it is not known.
  static CountryInfo? of(String code) => _byCode[code.toUpperCase()];

  /// Returns the English name for [code], falling back to the code itself.
  static String nameOf(String code) => of(code)?.name ?? code;
}
