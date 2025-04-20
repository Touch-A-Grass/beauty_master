part of 'order_details_bloc.dart';

@freezed
class OrderDetailsState with _$OrderDetailsState {
  const OrderDetailsState._();

  const factory OrderDetailsState({
    Order? order,
    @Default(true) bool isLoadingOrder,
    AppError? loadingOrderError,
    @Default(OrderUpdatingState.initial()) OrderUpdatingState discardingState,
    @Default(OrderUpdatingState.initial()) OrderUpdatingState confirmingState,
    @Default(OrderUpdatingState.initial()) OrderUpdatingState completingState,
    @Default(OrderUpdatingState.initial()) OrderUpdatingState changingTimeSlotState,
    List<StaffTimeSlot>? timeSlots,
  }) = _OrderDetailsState;

  bool get canDiscardOrder =>
      changingTimeSlotState is InitialOrderUpdatingState &&
      confirmingState is InitialOrderUpdatingState &&
      (order?.status == OrderStatus.pending || order?.status == OrderStatus.approved) &&
      !isLoadingOrder;

  bool get canApproveOrder =>
      changingTimeSlotState is InitialOrderUpdatingState &&
      discardingState is InitialOrderUpdatingState &&
      order?.status == OrderStatus.pending &&
      !isLoadingOrder;

  bool get canCompleteOrder =>
      discardingState is InitialOrderUpdatingState && order?.status == OrderStatus.approved && !isLoadingOrder;

  bool get canChangeTime =>
      (order?.status == OrderStatus.pending || order?.status == OrderStatus.approved) && !isLoadingOrder;
}

@freezed
sealed class OrderUpdatingState with _$OrderUpdatingState {
  const factory OrderUpdatingState.initial() = InitialOrderUpdatingState;

  const factory OrderUpdatingState.loading() = LoadingOrderUpdatingState;

  const factory OrderUpdatingState.error(AppError error) = ErrorOrderUpdatingState;
}
