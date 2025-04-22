part of 'calendar_bloc.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    @Default(true) bool isLoadingSchedule,
    @Default({}) Map<DateTime, DaySchedule> schedule,
  }) = _CalendarState;
}
