part of 'order_details_bloc.dart';

@freezed
class OrderDetailsEvent with _$OrderDetailsEvent {
  const factory OrderDetailsEvent.started() = _Started;

  const factory OrderDetailsEvent.orderRequested() = _OrderRequested;

  const factory OrderDetailsEvent.discardRequested(String reason) = _DiscardRequested;

  const factory OrderDetailsEvent.approveRequested() = _ApproveRequested;

  const factory OrderDetailsEvent.completeRequested() = _CompleteRequested;

  const factory OrderDetailsEvent.timeSlotsRequested() = _TimeSlotsRequested;

  const factory OrderDetailsEvent.changeTimeSlotRequested(DateTime date) = _ChangeTimeSlotRequested;

  const factory OrderDetailsEvent.unreadCountChanged(int count) = _UnreadCountChanged;
}
