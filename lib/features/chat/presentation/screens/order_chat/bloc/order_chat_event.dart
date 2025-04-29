part of 'order_chat_bloc.dart';

@freezed
class OrderChatEvent with _$OrderChatEvent {
  const factory OrderChatEvent.started() = _Started;

  const factory OrderChatEvent.sendMessageRequested(String message) = _SendMessageRequested;

  const factory OrderChatEvent.messageReceived(ChatEvent message) = _MessageReceived;

  const factory OrderChatEvent.messageRead(String messageId) = _MessageRead;

  const factory OrderChatEvent.markAsReadRequested() = _MarkAsReadRequested;
}
