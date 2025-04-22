import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_bloc.freezed.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final OrderRepository _orderRepository;

  CalendarBloc(this._orderRepository) : super(CalendarState()) {
    on<_Started>((event, emit) {
      var now = DateTime.now();
      while (now.weekday != 1) {
        now = now.subtract(const Duration(days: 1));
      }
      add(CalendarEvent.scheduleRequested(now));
    });
    on<_ScheduleRequested>((event, emit) async {
      emit(state.copyWith(isLoadingSchedule: true));
      try {
        final daysFuture = <DateTime, Future<DaySchedule>>{};
        for (var i = 0; i < 7; i++) {
          final day = event.date.add(Duration(days: i));
          daysFuture[day] = _orderRepository.getDaySchedule(day);
        }
        final days = <DateTime, DaySchedule>{};
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
