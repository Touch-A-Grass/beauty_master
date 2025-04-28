part of 'calendar_bloc.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent.started() = _Started;

  const factory CalendarEvent.scheduleRequested(DateTime date, {@Default(false) bool singleDay}) = _ScheduleRequested;

  const factory CalendarEvent.timeSlotAdded({required TimeInterval interval, required String venueId}) = _TimeSlotAdded;

  const factory CalendarEvent.timeSlotRemoved({required FreeTimeWorkloadTimeSlot timeSlot}) = _TimeSlotRemoved;

  const factory CalendarEvent.timeSlotEdited({
    required FreeTimeWorkloadTimeSlot timeSlot,
    required TimeInterval interval,
  }) = _TimeSlotEdited;
}
