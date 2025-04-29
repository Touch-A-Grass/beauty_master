import 'package:beauty_master/domain/models/chat_participant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required ChatParticipant participant,
    required DateTime createdAt,
    required DateTime? readAt,
    required bool isRead,
    required String text,
  }) = _ChatMessage;
}
