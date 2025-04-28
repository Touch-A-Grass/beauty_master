part of 'calendar_bloc.dart';

@freezed
class CalendarState with _$CalendarState {
  const CalendarState._();

  const factory CalendarState({
    @Default(true) bool isLoadingSchedule,
    @Default(false) bool isUpdatingSchedule,
    @Default({}) Map<DateTime, List<DaySchedule>> schedule,
  }) = _CalendarState;

  bool get isLoading => isLoadingSchedule || isUpdatingSchedule;
}
