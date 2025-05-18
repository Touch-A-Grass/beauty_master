import 'dart:typed_data';

import 'package:beauty_master/features/chat/domain/models/chat_message_info.dart';
import 'package:beauty_master/features/chat/domain/models/chat_participant.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required ChatParticipant participant,
    required ChatMessageInfo info,
    @Default(true) bool isSent,
  }) = _ChatMessage;
}

@freezed
sealed class ChatMessageContent with _$ChatMessageContent {
  const factory ChatMessageContent.text(String text) = TextChatMessageContent;

  const factory ChatMessageContent.image(Uint8List bytes) = ImageChatMessageContent;
}
