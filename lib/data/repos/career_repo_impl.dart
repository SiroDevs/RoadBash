// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../domain/models/career.dart';
import '../../domain/repos/career_repo.dart';
import '../sources/local/pref_keys.dart';
import '../sources/local/prefs_source.dart';

/// Keeps the streak and best times of each account in local storage.
@LazySingleton(as: CareerRepo)
class CareerRepoImpl implements CareerRepo {
  CareerRepoImpl(this._prefs);

  final PrefsSource _prefs;

  String _key(String account) => '${PrefKeys.career}:$account';

  @override
  Future<Career> load(String account) async =>
      Career.decode(_prefs.getString(_key(account)));

  @override
  Future<void> save(String account, Career career) async =>
      _prefs.setString(_key(account), career.encode());
}
