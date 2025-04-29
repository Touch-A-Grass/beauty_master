import 'package:beauty_master/data/models/dto/chat_log_dto.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message_info.dart';
import 'package:beauty_master/features/chat/domain/models/chat_status_log.dart';
import 'package:flutter/cupertino.dart';

class ChatEventInfoMapper {
  const ChatEventInfoMapper._();

  static ChatEventInfo? fromDto(ChatLogDto dto) {
    try {
      return switch (dto.type) {
        'Message' => ChatEventInfo.message(
          ChatMessageInfo(
            id: dto.id!,
            text: dto.text!,
            senderId: dto.senderId!,
            createdAt: dto.createdAt!.toLocal(),
            readAt: dto.readAt?.toLocal(),
            isRead: dto.isRead!,
          ),
        ),
        'Discarded' || 'Completed' || 'Approved' => ChatEventInfo.statusLog(
          ChatStatusLog.orderStatus(id: dto.id!, text: dto.text!, status: OrderStatus.fromJson(dto.type)),
        ),
        'Created' ||
        'Moved' ||
        'Review' => ChatEventInfo.statusLog(ChatStatusLog.misc(id: dto.id!, text: dto.text!, type: dto.type)),
        _ => null,
      };
    } catch (e, t) {
      debugPrintStack(stackTrace: t);
      return null;
    }
  }
}
