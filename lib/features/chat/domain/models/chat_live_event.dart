import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_live_event.freezed.dart';

@freezed
sealed class ChatLiveEvent with _$ChatLiveEvent {
  const factory ChatLiveEvent.eventReceived(ChatEventInfo event) = EventReceivedChatLiveEvent;

  const factory ChatLiveEvent.messageRead(String messageId) = MessageReadChatLiveEvent;
}
