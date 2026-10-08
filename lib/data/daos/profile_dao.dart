// Package imports:
import 'package:froom/froom.dart';

// Project imports:
import '../entities/profile_entity.dart';

@dao
abstract class ProfileDao {
  @Query('SELECT * FROM profile WHERE id = 1')
  Future<ProfileEntity?> find();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> save(ProfileEntity profile);
}
