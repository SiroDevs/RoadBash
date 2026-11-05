// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/career.dart';
import '../../domain/repos/career_repo.dart';
import '../sources/local/pref_keys.dart';
import '../sources/local/prefs_source.dart';

/// Keeps the career in local storage.
@LazySingleton(as: CareerRepo)
class CareerRepoImpl implements CareerRepo {
  CareerRepoImpl(this._prefs);

  final PrefsSource _prefs;

  @override
  Future<Career> load() async =>
      Career.decode(_prefs.getString(PrefKeys.career));

  @override
  Future<void> save(Career career) async =>
      _prefs.setString(PrefKeys.career, career.encode());
}
