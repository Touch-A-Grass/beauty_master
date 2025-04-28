import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';
import 'package:beauty_master/domain/use_cases/change_time_slot_use_case.dart';
import 'package:beauty_master/presentation/util/date_time_util.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_bloc.freezed.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final OrderRepository _orderRepository;
  final StaffRepository _staffRepository;
  final ChangeTimeSlotUseCase _changeTimeSlotUseCase;

  CalendarBloc(this._orderRepository, this._staffRepository, this._changeTimeSlotUseCase) : super(CalendarState()) {
    on<_Started>((event, emit) {
      var now = DateTime.now();
      while (now.weekday != 1) {
        now = now.subtract(const Duration(days: 1));
      }
      add(CalendarEvent.scheduleRequested(now));
    });
    on<_TimeSlotAdded>((event, emit) async {
      emit(state.copyWith(isUpdatingSchedule: true));
      try {
        final date = event.interval.start.dateOnly;
        final schedule = state.schedule[date]?.firstWhereOrNull((e) => e.venueId == event.venueId);
        final oldIntervals =
            schedule?.workload
                .where((e) => e is FreeTimeWorkloadTimeSlot && schedule.venueId == event.venueId)
                .map((e) => e.timeInterval)
                .toList();
        await _changeTimeSlotUseCase.execute(
          date: date,
          intervals: [...oldIntervals ?? [], event.interval],
          venueId: event.venueId,
          schedule: schedule,
        );
        add(CalendarEvent.scheduleRequested(date, singleDay: true));
      } catch (_) {}
      emit(state.copyWith(isUpdatingSchedule: false));
    });
    on<_TimeSlotEdited>((event, emit) async {
      emit(state.copyWith(isUpdatingSchedule: true));
      try {
        final date = event.interval.start.dateOnly;
        final schedule = state.schedule[date]?.firstWhereOrNull((e) => e.venueId == event.timeSlot.venueId);
        final oldIntervals =
            schedule?.workload
                .where(
                  (e) =>
                      e is FreeTimeWorkloadTimeSlot &&
                      schedule.venueId == event.timeSlot.venueId &&
                      e.id != event.timeSlot.id,
                )
                .map((e) => e.timeInterval)
                .toList() ??
            [];
        await _changeTimeSlotUseCase.execute(
          date: date,
          intervals: [...oldIntervals, event.interval],
          venueId: event.timeSlot.venueId,
          schedule: schedule,
        );
        add(CalendarEvent.scheduleRequested(date, singleDay: true));
      } catch (e, stack) {
        debugPrintStack(stackTrace: stack, label: e.toString());
      }
      emit(state.copyWith(isUpdatingSchedule: false));
    });
    on<_TimeSlotRemoved>((event, emit) async {
      emit(state.copyWith(isUpdatingSchedule: true));
      try {
        final date = event.timeSlot.timeInterval.start.dateOnly;
        final schedule = state.schedule[date]?.firstWhereOrNull((e) => e.venueId == event.timeSlot.venueId);
        final oldIntervals =
            schedule?.workload
                .where(
                  (e) =>
                      e is FreeTimeWorkloadTimeSlot &&
                      schedule.venueId == schedule.venueId &&
                      e.id != event.timeSlot.id,
                )
                .map((e) => e.timeInterval)
                .toList();
        await _changeTimeSlotUseCase.execute(
          date: date,
          intervals: oldIntervals ?? [],
          venueId: schedule!.venueId,
          schedule: schedule,
        );
        add(CalendarEvent.scheduleRequested(date, singleDay: true));
      } catch (_) {}
      emit(state.copyWith(isUpdatingSchedule: false));
    });
    on<_ScheduleRequested>((event, emit) async {
      emit(state.copyWith(isLoadingSchedule: true));
      try {
        final daysFuture = <DateTime, Future<List<DaySchedule>>>{};
        for (var i = 0; i < (event.singleDay ? 1 : 7); i++) {
          final day = event.date.add(Duration(days: i)).dateOnly;
          daysFuture[day] = _orderRepository.getDaySchedule(day);
        }
        final days = Map.of(state.schedule);
        for (final day in daysFuture.keys) {
          final schedule = await daysFuture[day]!;
          days[day] = schedule;
        }
        emit(state.copyWith(schedule: days));
      } catch (e, trace) {
        debugPrintStack(stackTrace: trace);
      }
      emit(state.copyWith(isLoadingSchedule: false));
    }, transformer: restartable());
  }
}
