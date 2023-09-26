import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedulebooking/domain/entities/booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../di/di.dart';
import '../../../domain/use_case/use_case.dart';
import '../../base/base.dart';

class ScheduleBookingBloc extends BaseBloc {
  final _getBookingsUseCase = getIt.get<GetBookingsUseCase>();
  final _updateBookingUseCase = getIt.get<UpdateBookingUseCase>();
  final _events = BookingDataSource(source: [], resourceColl: []);
  final _formatter = DateFormat('HH:mm');

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
      DateTime startTime = item.startTime!;
      DateTime endTime = item.endTime!;
      appointment.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject:
              'Booked\n${_formatter.format(startTime)}-${_formatter.format(endTime)}',
          resourceIds: [...?item.resourceIds],
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

  int round5minutes(int value) {
    return value = (value / 5).ceil() * 5;
  }

  void dragToUpdateAppointment(
      AppointmentDragEndDetails appointmentDragEndDetails) async {
    final appointmentSelected = appointmentDragEndDetails.appointment;
    if (appointmentSelected is Appointment) {
      final appointmentOld = await _getBookingsUseCase
          .getBookingById(appointmentSelected.id.toString());
      bool shouldUpdateBooking = true;
      DateTime startTime = DateTime(
          appointmentSelected.startTime.year,
          appointmentSelected.startTime.month,
          appointmentSelected.startTime.day,
          appointmentSelected.startTime.hour,
          round5minutes(
            appointmentSelected.startTime.minute,
          ));
      DateTime endTime = startTime.add(const Duration(minutes: 119));
      if (endTime.day != startTime.day) {
        shouldUpdateBooking = false;
      }
      for (final Appointment appointment in _events.appointments ?? []) {
        final existsApp = appointment.resourceIds
            ?.firstWhere(
                (x) =>
                    x.toString() ==
                        appointmentSelected.resourceIds![0].toString() &&
                    appointmentSelected.id != appointment.id,
                orElse: () => '')
            .toString();
        if (existsApp!.isNotEmpty) {
          if (startTime.microsecondsSinceEpoch >=
                  appointment.startTime.microsecondsSinceEpoch &&
              startTime.microsecondsSinceEpoch <=
                  appointment.endTime.microsecondsSinceEpoch) {
            shouldUpdateBooking = false;
          }
          if (endTime.microsecondsSinceEpoch >=
                  appointment.startTime.microsecondsSinceEpoch &&
              startTime.microsecondsSinceEpoch <=
                  appointment.endTime.microsecondsSinceEpoch) {
            shouldUpdateBooking = false;
          }
        }
      }
      Appointment appointment = _events.appointments!
          .firstWhere((element) => element.id == appointmentSelected.id);
      if (!shouldUpdateBooking) {
        appointment.startTime = appointmentOld!.startTime!;
        appointment.endTime = appointmentOld.endTime!;
        appointment.subject =
            'Booked\n${_formatter.format(appointmentOld.startTime!)}-${_formatter.format(appointmentOld.endTime!)}';
        appointment.resourceIds = [...?appointmentOld.resourceIds];
      } else {
        appointment.startTime = startTime;
        appointment.endTime = endTime;
        appointment.subject =
            'Booked\n${_formatter.format(startTime)}-${_formatter.format(endTime)}';
        appointment.resourceIds = [
          appointmentSelected.resourceIds![0].toString()
        ];
        _updateBookingUseCase.updateBooking(Booking(
          id: appointment.id.toString(),
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          subject: appointment.subject,
          resourceIds:
              appointment.resourceIds?.map((e) => e.toString()).toList(),
        ));
      }
      _events.notifyListeners(
        CalendarDataSourceAction.reset,
        _events.appointments!,
      );
    }
  }

  void addAnAppointment(CalendarTapDetails calendarTapDetails) {
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
      DateTime startTime = selectedDate;
      DateTime endTime = selectedDate.add(const Duration(minutes: 119));
      if (endTime.day != startTime.day) {
        return;
      }
      for (final Appointment appointment in _events.appointments ?? []) {
        final existsApp = appointment.resourceIds
            ?.firstWhere(
                (x) =>
                    x.toString() == calendarTapDetails.resource?.id.toString(),
                orElse: () => '')
            .toString();
        if (existsApp!.isNotEmpty) {
          if (startTime.microsecondsSinceEpoch >=
                  appointment.startTime.microsecondsSinceEpoch &&
              startTime.microsecondsSinceEpoch <=
                  appointment.endTime.microsecondsSinceEpoch) {
            return;
          }
          if (endTime.microsecondsSinceEpoch >=
                  appointment.startTime.microsecondsSinceEpoch &&
              startTime.microsecondsSinceEpoch <=
                  appointment.endTime.microsecondsSinceEpoch) {
            return;
          }
        }
      }
      appointment.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          startTimeZone: '',
          endTimeZone: '',
          subject:
              'Booked\n${_formatter.format(startTime)}-${_formatter.format(endTime)}',
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
