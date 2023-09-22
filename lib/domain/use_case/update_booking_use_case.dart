part of use_case;

abstract class UpdateBookingUseCase {
  Future<bool> addBooking(Booking booking);

  Future<bool> removeBooking(String bookingId);
}

class UpdateBookingUseCaseImpl implements UpdateBookingUseCase {
  final LocalDBRepo localDBRepo;

  UpdateBookingUseCaseImpl({required this.localDBRepo});

  @override
  Future<bool> addBooking(Booking booking) async {
    try {
      await localDBRepo.putOneItem<Booking>(booking);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> removeBooking(String bookingId) async {
    try {
      var booking = await localDBRepo
          .getCollection<Booking>()
          .filter()
          .idEqualTo(bookingId)
          .findFirst();
      if (booking != null) {
        return await localDBRepo.deleteOneItem<Booking>(booking.localId);
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
