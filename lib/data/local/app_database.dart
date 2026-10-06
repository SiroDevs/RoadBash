// Dart imports:
import 'dart:async';

// Package imports:
import 'package:froom/froom.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// Project imports:
import 'daos/profile_dao.dart';
import 'daos/race_record_dao.dart';
import 'entities/profile_entity.dart';
import 'entities/race_record_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ProfileEntity, RaceRecordEntity])
abstract class AppDatabase extends FroomDatabase {
  ProfileDao get profileDao;
  RaceRecordDao get raceRecordDao;
}
