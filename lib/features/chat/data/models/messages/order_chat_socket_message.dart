import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_chat_socket_message.freezed.dart';
part 'order_chat_socket_message.g.dart';

@freezed
sealed class OrderChatSocketMessage with _$OrderChatSocketMessage {
  const factory OrderChatSocketMessage.messageReceived({
    required String id,
    required String message,
    required String senderId,
    required DateTime createdAt,
    required String messageId,
  }) = MessageReceivedOrderChatSocketMessage;

  const factory OrderChatSocketMessage.messageRead({required String messageId}) = MessageReadOrderChatSocketMessage;

  factory OrderChatSocketMessage.fromJson(Map<String, dynamic> json) => _$OrderChatSocketMessageFromJson(json);
}
