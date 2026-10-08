// Package imports:
import 'package:froom/froom.dart';

@Entity(tableName: 'race_record')
class RaceRecordEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String scene;
  final int place;
  final int timeMs;
  final String playerName;
  final int finishedAt;

  RaceRecordEntity(
    this.id,
    this.scene,
    this.place,
    this.timeMs,
    this.playerName,
    this.finishedAt,
  );
}
