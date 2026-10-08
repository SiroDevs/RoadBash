// Package imports:
import 'package:froom/froom.dart';

// Project imports:
import '../entities/race_record_entity.dart';

@dao
abstract class RaceRecordDao {
  @Query('SELECT * FROM race_record')
  Future<List<RaceRecordEntity>> all();

  @insert
  Future<void> add(RaceRecordEntity record);
}
