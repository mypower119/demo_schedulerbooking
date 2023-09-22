part of '../di.dart';

class RepositoryModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt.registerLazySingleton<LocalDBRepo>(
      () => LocalDBRepoImpl(
        isarDatabase: getIt<IsarDatabase>(),
      ),
    );
  }
}
