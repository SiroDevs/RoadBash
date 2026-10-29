// Project imports:
import '../models/race_record.dart';

/// Contract for loading and saving race records.
abstract interface class RaceRepo {
  Future<List<RaceRecord>> all();
  Future<void> add(RaceRecord record);
}
