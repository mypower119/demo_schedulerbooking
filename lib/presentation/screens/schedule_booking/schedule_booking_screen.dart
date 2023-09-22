import 'package:flutter/material.dart';
import 'package:schedulebooking/presentation/screens/schedule_booking/schedule_booking_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftScheduler extends StatefulWidget {
  const ShiftScheduler({Key? key}) : super(key: key);

  @override
  State createState() => _ShiftSchedulerState();
}

class _ShiftSchedulerState extends State {
  final CalendarController _calendarController = CalendarController();
  final ScheduleBookingBloc _scheduleBookingBloc = ScheduleBookingBloc();

  @override
  void initState() {
    _calendarController.view = CalendarView.timelineDay;
    _scheduleBookingBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    _scheduleBookingBloc.dispose();
    super.dispose();
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {}

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    _scheduleBookingBloc.addAnAppointment(calendarTapDetails, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _getBookingScheduler(
          _scheduleBookingBloc.events,
          _onCalendarTapped,
          _onViewChanged,
        ),
      ),
    );
  }

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getBookingScheduler(
      [CalendarDataSource? calendarDataSource,
      dynamic calendarTapCallback,
      dynamic viewChangedCallback]) {
    return SfCalendar(
      showDatePickerButton: false,
      controller: _calendarController,
      showNavigationArrow: false,
      dataSource: calendarDataSource,
      onViewChanged: viewChangedCallback,
      onTap: calendarTapCallback,
      allowAppointmentResize: true,
      allowDragAndDrop: true,
      timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 90),
        timeInterval: Duration(hours: 1),
        // timeIntervalHeight: 100,
      ),
      viewNavigationMode: ViewNavigationMode.none,
      resourceViewSettings: const ResourceViewSettings(
        size: 60,
        showAvatar: false,
      ),
    );
  }
}
