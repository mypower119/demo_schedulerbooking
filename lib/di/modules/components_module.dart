part of '../di.dart';

class ComponentsModule extends DIModule {
  @override
  Future<void> provides() async {
    IsarDatabase isarDatabase = IsarDatabaseImpl();
    await isarDatabase.init();

    getIt.registerLazySingleton<IsarDatabase>(
          () => isarDatabase,
    );
  }
}
