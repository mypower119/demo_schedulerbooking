part of repository;

abstract class LocalDBRepo {
  Future<void> clearImportedDatabase();

  void clearDatabase<T>();

  Future<void> putAll<T>(List<T> data);

  Future<List<T>> getData<T>({int? limit, int? page});

  Future<void> putOneItem<T>(T model, {Future<void> Function()? saveLink});

  Future<T?> getOneItem<T>(Id id);

  Future<bool> deleteOneItem<T>(Id id);

  Future<bool> deleteItems<T>(List<Id> ids);

  IsarCollection<T> getCollection<T>();
}

class LocalDBRepoImpl implements LocalDBRepo {
  final IsarDatabase isarDatabase;

  LocalDBRepoImpl({required this.isarDatabase});

  @override
  void clearDatabase<T>() {
    isarDatabase.getInstance().writeTxn(() async {
      await _clearCollectionDatabase<T>();
    });
  }

  @override
  Future<void> clearImportedDatabase() async {
    await isarDatabase.getInstance().writeTxn(() async {
      await Future.wait([
        _clearCollectionDatabase<Booking>(),
      ]);
    });
  }

  Future<void> _clearCollectionDatabase<T>() async {
    await isarDatabase.getInstance().collection<T>().clear();
  }

  @override
  Future<void> putAll<T>(List<T> data) async {
    await isarDatabase.getInstance().writeTxn(() async {
      await isarDatabase.getInstance().collection<T>().putAll(data);
    });
  }

  @override
  Future<List<T>> getData<T>({int? limit, int? page}) async {
    int offset = page.offset(limit);
    return await isarDatabase
        .getInstance()
        .collection<T>()
        .where()
        .optional(page != null, (q) => q.offset(offset).limit(limit.limit))
        .findAll();
  }

  @override
  Future<void> putOneItem<T>(T model,
      {Future<void> Function()? saveLink}) async {
    await isarDatabase.getInstance().writeTxn(() async {
      await isarDatabase.getInstance().collection<T>().put(model);
      await saveLink?.call();
    });
  }

  @override
  Future<T?> getOneItem<T>(Id id) async {
    return await isarDatabase.getInstance().collection<T>().get(id);
  }

  @override
  IsarCollection<T> getCollection<T>() {
    return isarDatabase.getInstance().collection<T>();
  }

  @override
  Future<bool> deleteOneItem<T>(Id id) async {
    bool isSuccess = false;
    isSuccess = await isarDatabase.getInstance().writeTxn(() async {
      return await isarDatabase.getInstance().collection<T>().delete(id);
    });
    return isSuccess;
  }

  @override
  Future<bool> deleteItems<T>(List<Id> ids) async {
    bool isSuccess = false;
    isSuccess = await isarDatabase.getInstance().writeTxn(() async {
      return (await isarDatabase
              .getInstance()
              .collection<T>()
              .deleteAll(ids)) ==
          ids.length;
    });
    return isSuccess;
  }
}
