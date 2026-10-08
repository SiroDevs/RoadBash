// Package imports:
import 'package:froom/froom.dart';

@Entity(tableName: 'profile')
class ProfileEntity {
  @PrimaryKey()
  final int id;
  final String name;
  final int master;
  final int music;
  final int engine;
  final int effects;

  ProfileEntity(
    this.id,
    this.name,
    this.master,
    this.music,
    this.engine,
    this.effects,
  );
}
