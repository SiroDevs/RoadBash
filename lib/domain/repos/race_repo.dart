// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../models/race_record.dart';

@lazySingleton
class RaceRepo {
  final List<RaceRecord> _records = [];

  Future<List<RaceRecord>> all() async => List.unmodifiable(_records);

  Future<void> add(RaceRecord record) async {
    _records.add(record);
  }
}
