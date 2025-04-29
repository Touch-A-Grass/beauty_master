import 'package:beauty_master/features/chat/domain/models/chat_message.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message_info.dart';
import 'package:beauty_master/features/chat/domain/models/chat_status_log.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.message(ChatMessage message) = MessageChatEvent;

  const factory ChatEvent.statusLog(ChatStatusLog log) = StatusLogChatEvent;
}


@freezed
sealed class ChatEventInfo with _$ChatEventInfo {
  const factory ChatEventInfo.message(ChatMessageInfo message) = MessageChatEventInfo;

  const factory ChatEventInfo.statusLog(ChatStatusLog log) = StatusLogChatEventInfo;
}