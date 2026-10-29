// Project imports:
import '../models/race_record.dart';

abstract interface class RaceRepo {
  Future<List<RaceRecord>> all();
  Future<void> add(RaceRecord record);
}
