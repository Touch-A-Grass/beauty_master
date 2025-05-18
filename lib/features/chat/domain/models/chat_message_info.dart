import 'package:beauty_master/features/chat/domain/models/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_info.freezed.dart';

@freezed
sealed class ChatMessageInfo with _$ChatMessageInfo {
  const factory ChatMessageInfo({
    required String senderId,
    required DateTime createdAt,
    required DateTime? readAt,
    required bool isRead,
    required ChatMessageContent content,
    required String id,
  }) = _ChatMessageInfo;
}
