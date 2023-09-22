part of 'local_data_source.dart';

abstract class IsarDatabase {
  Future<void> init();

  Isar getInstance();

  void close();
}

class IsarDatabaseImpl implements IsarDatabase {
  static late final Isar _isar;

  @override
  Future<Isar> init() async {
    if (Isar.getInstance() == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          BookingSchema,
        ],
        directory: dir.path,
      );
      await performMigrationIfNeeded(_isar);
    } else {
      _isar = Isar.getInstance()!;
    }
    return _isar;
  }

  @override
  Isar getInstance() => _isar;

  Future<void> performMigrationIfNeeded(Isar isar) async {}

  Future<void> migrateV1ToV2(Isar isar) async {}

  Future<void> migrateV2ToV3(Isar isar) async {}

  @override
  void close() {
    _isar.close();
  }
}
