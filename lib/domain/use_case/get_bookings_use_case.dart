part of use_case;

abstract class GetBookingsUseCase {
  Future<List<Booking>> getListBooking();
}

class GetBookingUseCaseImpl implements GetBookingsUseCase {
  final LocalDBRepo localDBRepo;

  GetBookingUseCaseImpl({required this.localDBRepo});

  @override
  Future<List<Booking>> getListBooking() async {
    return await localDBRepo.getData<Booking>();
  }
}
