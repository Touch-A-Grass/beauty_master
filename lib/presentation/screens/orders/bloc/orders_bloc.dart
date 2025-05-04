import 'package:beauty_master/domain/models/app_error.dart';
import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/paging.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/presentation/util/subscription_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> with SubscriptionBloc {
  final OrderRepository _orderRepository;

  OrdersBloc(this._orderRepository) : super(OrdersState(selectedDate: DateTime.now(), selectedMonth: DateTime.now())) {
    on<_Started>((event, emit) {
      add(OrdersEvent.selectedMonthChanged(state.selectedMonth));
      add(OrdersEvent.selectedDayChanged(state.selectedDate));
    });
    on<_SelectedMonthChanged>((event, emit) async {
      emit(state.copyWith(selectedMonth: event.month, isLoadingCalendar: true, monthStatus: null));
      try {
        final monthStatus = await _orderRepository.getWorkload(event.month);
        emit(state.copyWith(monthStatus: monthStatus, isLoadingCalendar: false));
      } catch (_) {
        emit(state.copyWith(isLoadingCalendar: false));
      }
    }, transformer: restartable());
    on<_SelectedDayChanged>((event, emit) {
      if (state.selectedMonth.month != event.day.month) {
        add(OrdersEvent.selectedMonthChanged(event.day));
      }
      emit(state.copyWith(selectedDate: event.day));
      add(OrdersEvent.ordersRequested(refresh: true));
    });
    on<_OrdersRequested>((event, emit) async {
      if (event.refresh) {
        emit(state.copyWith(isLoadingOrders: true, orders: Paging()));
      }
      try {
        final orders = await _orderRepository.getOrders(
          limit: 10,
          offset: state.orders.offset(event.refresh),
          date: state.selectedDate,
        );
        emit(state.copyWith(orders: state.orders.next(orders, refresh: event.refresh), isLoadingOrders: false));
      } catch (e, trace) {
        debugPrintStack(stackTrace: trace);
        emit(state.copyWith(loadingError: AppError.fromObject(e), isLoadingOrders: false));
      }
    }, transformer: restartable());
    on<_OrderChanged>((event, emit) {
      emit(state.copyWith(orders: state.orders.replaceWith(event.order, (e) => e.id)));
    });
    on<_UnreadMessageCountChanged>((event, emit) {
      emit(
        state.copyWith(
          orders: state.orders.copyWith(
            data:
                state.orders.data
                    .map((order) => order.id == event.orderId ? order.copyWith(unreadMessageCount: event.count) : order)
                    .toList(),
          ),
        ),
      );
    });
    subscribe(_orderRepository.watchOrderChatUnreadCountAll(), (event) {
      add(OrdersEvent.unreadMessageCountChanged(event.orderId, event.count));
    });
    subscribe(_orderRepository.watchOrderChangedEvent(), (order) {
      add(OrdersEvent.orderChanged(order: order));
    });
  }
}
