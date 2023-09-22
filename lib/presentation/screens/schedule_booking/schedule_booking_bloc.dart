import 'package:flutter/material.dart';
import 'package:schedulebooking/domain/entities/booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../di/di.dart';
import '../../../domain/use_case/use_case.dart';
import '../../base/base.dart';

class ScheduleBookingBloc extends BaseBloc {
  final _getBookingsUseCase = getIt.get<GetBookingsUseCase>();
  final _updateBookingUseCase = getIt.get<UpdateBookingUseCase>();
  final _events = BookingDataSource(source: [], resourceColl: []);

  BookingDataSource get events => _events;

  void init() {
    _initResources();
    _initAppointments();
  }

  @override
  void dispose() {
    _events.resources?.clear();
    _events.appointments?.clear();
  }

  void _initResources() {
    for (int i = 1; i <= 30; i++) {
      _events.resources?.add(CalendarResource(
        displayName: 'seat $i',
        id: '000$i',
        color: Colors.lightGreen,
      ));
    }
  }

  Future<void> _initAppointments() async {
    var bookings = await _getBookingsUseCase.getListBooking();
    final List<Appointment> appointment = <Appointment>[];
    for (final item in bookings) {
      appointment.add(
        Appointment(
          startTime: item.startTime!,
          endTime: item.endTime!,
          subject: item.subject ?? '',
          resourceIds: item.resourceIds,
          id: item.id,
          recurrenceRule: null,
          startTimeZone: '',
          endTimeZone: '',
        ),
      );
    }
    _events.appointments?.addAll(appointment);
    _events.notifyListeners(
      CalendarDataSourceAction.add,
      appointment,
    );
  }

  void addAnAppointment(
      CalendarTapDetails calendarTapDetails, BuildContext context) {
    Appointment? selectedAppointment;
    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.targetElement == CalendarElement.appointment) {
      final dynamic appointment = calendarTapDetails.appointments![0];
      if (appointment is Appointment) {
        selectedAppointment = appointment;
      }
    }
    final DateTime selectedDate = calendarTapDetails.date ?? DateTime.now();
    final List<Appointment> appointment = <Appointment>[];
    if (selectedAppointment != null) {
      _events.appointments!.removeAt(
        _events.appointments!.indexOf(selectedAppointment),
      );
      _events.notifyListeners(
        CalendarDataSourceAction.remove,
        <Appointment>[selectedAppointment],
      );
      _updateBookingUseCase.removeBooking(selectedAppointment.id.toString());
    } else {
      appointment.add(
        Appointment(
          startTime: selectedDate,
          endTime: selectedDate.add(const Duration(minutes: 120)),
          startTimeZone: '',
          endTimeZone: '',
          subject: 'Booked',
          resourceIds: [calendarTapDetails.resource?.id ?? ''],
          id: selectedAppointment?.id,
          recurrenceRule: null,
        ),
      );
      _events.appointments!.add(appointment[0]);
      _events.notifyListeners(
        CalendarDataSourceAction.add,
        appointment,
      );
      _updateBookingUseCase.addBooking(Booking(
        id: appointment[0].id.toString(),
        startTime: appointment[0].startTime,
        endTime: appointment[0].endTime,
        subject: appointment[0].subject,
        resourceIds:
            appointment[0].resourceIds?.map((e) => e.toString()).toList(),
      ));
    }
  }
}

class BookingDataSource extends CalendarDataSource {
  BookingDataSource({
    required List<Appointment> source,
    required List<CalendarResource> resourceColl,
  }) {
    appointments = source;
    resources = resourceColl;
  }
}
