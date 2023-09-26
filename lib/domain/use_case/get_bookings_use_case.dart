part of use_case;

abstract class GetBookingsUseCase {
  Future<List<Booking>> getListBooking();

  Future<Booking?> getBookingById(String bookingId);
}

class GetBookingUseCaseImpl implements GetBookingsUseCase {
  final LocalDBRepo localDBRepo;

  GetBookingUseCaseImpl({required this.localDBRepo});

  @override
  Future<List<Booking>> getListBooking() async {
    return await localDBRepo.getData<Booking>();
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    return await localDBRepo.getCollection<Booking>().filter().idEqualTo(bookingId).findFirst();
  }
}
