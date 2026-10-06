// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FroomGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FroomAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(path, _migrations, _callback);
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProfileDao? _profileDaoInstance;

  RaceRecordDao? _raceRecordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
          database,
          startVersion,
          endVersion,
          migrations,
        );

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `profile` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `master` INTEGER NOT NULL, `music` INTEGER NOT NULL, `engine` INTEGER NOT NULL, `effects` INTEGER NOT NULL, PRIMARY KEY (`id`))',
        );
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `race_record` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `scene` TEXT NOT NULL, `place` INTEGER NOT NULL, `timeMs` INTEGER NOT NULL, `playerName` TEXT NOT NULL, `finishedAt` INTEGER NOT NULL)',
        );

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProfileDao get profileDao {
    return _profileDaoInstance ??= _$ProfileDao(database, changeListener);
  }

  @override
  RaceRecordDao get raceRecordDao {
    return _raceRecordDaoInstance ??= _$RaceRecordDao(database, changeListener);
  }
}

class _$ProfileDao extends ProfileDao {
  _$ProfileDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database),
      _profileEntityInsertionAdapter = InsertionAdapter(
        database,
        'profile',
        (ProfileEntity item) => <String, Object?>{
          'id': item.id,
          'name': item.name,
          'master': item.master,
          'music': item.music,
          'engine': item.engine,
          'effects': item.effects,
        },
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProfileEntity> _profileEntityInsertionAdapter;

  @override
  Future<ProfileEntity?> find() async {
    return _queryAdapter.query(
      'SELECT * FROM profile WHERE id = 1',
      mapper: (Map<String, Object?> row) => ProfileEntity(
        row['id'] as int,
        row['name'] as String,
        row['master'] as int,
        row['music'] as int,
        row['engine'] as int,
        row['effects'] as int,
      ),
    );
  }

  @override
  Future<void> save(ProfileEntity profile) async {
    await _profileEntityInsertionAdapter.insert(
      profile,
      OnConflictStrategy.replace,
    );
  }
}

class _$RaceRecordDao extends RaceRecordDao {
  _$RaceRecordDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database),
      _raceRecordEntityInsertionAdapter = InsertionAdapter(
        database,
        'race_record',
        (RaceRecordEntity item) => <String, Object?>{
          'id': item.id,
          'scene': item.scene,
          'place': item.place,
          'timeMs': item.timeMs,
          'playerName': item.playerName,
          'finishedAt': item.finishedAt,
        },
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RaceRecordEntity> _raceRecordEntityInsertionAdapter;

  @override
  Future<List<RaceRecordEntity>> all() async {
    return _queryAdapter.queryList(
      'SELECT * FROM race_record',
      mapper: (Map<String, Object?> row) => RaceRecordEntity(
        row['id'] as int?,
        row['scene'] as String,
        row['place'] as int,
        row['timeMs'] as int,
        row['playerName'] as String,
        row['finishedAt'] as int,
      ),
    );
  }

  @override
  Future<void> add(RaceRecordEntity record) async {
    await _raceRecordEntityInsertionAdapter.insert(
      record,
      OnConflictStrategy.abort,
    );
  }
}
