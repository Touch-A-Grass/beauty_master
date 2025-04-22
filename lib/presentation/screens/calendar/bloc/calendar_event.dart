part of 'calendar_bloc.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent.started() = _Started;

  const factory CalendarEvent.scheduleRequested(DateTime date) = _ScheduleRequested;
}
