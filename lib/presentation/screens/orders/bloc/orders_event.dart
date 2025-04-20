part of 'orders_bloc.dart';

@freezed
class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.started() = _Started;

  const factory OrdersEvent.ordersRequested({@Default(false) bool refresh}) = _OrdersRequested;

  const factory OrdersEvent.orderChanged({required Order order}) = _OrderChanged;

  const factory OrdersEvent.selectedMonthChanged(DateTime month) = _SelectedMonthChanged;

  const factory OrdersEvent.selectedDayChanged(DateTime day) = _SelectedDayChanged;
}
