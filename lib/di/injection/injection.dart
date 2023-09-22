part of '../di.dart';

GetIt getIt = GetIt.instance;

class Injection {
  Injection._();

  static Future<void> inject() async {
    await ComponentsModule().provides();
    await ApiModule().provides();
    await RepositoryModule().provides();
    await UseCaseModule().provides();
    await BlocModule().provides();
  }
}
