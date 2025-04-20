part of 'orders_bloc.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(Paging()) Paging<Order> orders,
    @Default(true) bool isLoadingOrders,
    AppError? loadingError,
    required DateTime selectedDate,
    required DateTime selectedMonth,
    CalendarMonthStatus? monthStatus,
    @Default(true) bool isLoadingCalendar,
  }) = _OrdersState;
}
