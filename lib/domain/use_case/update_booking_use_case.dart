part of use_case;

abstract class UpdateBookingUseCase {
  Future<bool> addBooking(Booking booking);

  Future<bool> updateBooking(Booking booking);

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

  @override
  Future<bool> updateBooking(Booking booking) async {
    try {
      var updateBooking = await localDBRepo
          .getCollection<Booking>()
          .filter()
          .idEqualTo(booking.id ?? '')
          .findFirst();
      if (updateBooking != null) {
        updateBooking.startTime = booking.startTime;
        updateBooking.endTime = booking.endTime;
        updateBooking.subject = booking.subject;
        updateBooking.resourceIds = booking.resourceIds;
        await localDBRepo.putOneItem<Booking>(updateBooking);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
