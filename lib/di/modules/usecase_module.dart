part of '../di.dart';

class UseCaseModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt
      ..registerLazySingleton<GetBookingsUseCase>(
        () => GetBookingUseCaseImpl(
          localDBRepo: getIt.get<LocalDBRepo>(),
        ),
      )
      ..registerLazySingleton<UpdateBookingUseCase>(
        () => UpdateBookingUseCaseImpl(
          localDBRepo: getIt.get<LocalDBRepo>(),
        ),
      );
  }
}
