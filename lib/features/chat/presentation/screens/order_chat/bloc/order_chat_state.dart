part of 'order_chat_bloc.dart';

@freezed
class OrderChatState with _$OrderChatState {
  const factory OrderChatState({
    @Default(LoadingState.progress()) LoadingState<List<ChatEvent>> messagesState,
    @Default(LoadingState.progress()) LoadingState<Order> orderState,
    @Default(SendingState.initial()) SendingState sendingMessageState,
    @Default({}) Map<String, ChatParticipant> participants,
  }) = _OrderChatState;
}
