import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_info.freezed.dart';
part 'chat_message_info.g.dart';

@freezed
sealed class ChatMessageInfo with _$ChatMessageInfo {
  const factory ChatMessageInfo({
    required String senderId,
    required DateTime createdAt,
    required DateTime? readAt,
    required bool isRead,
    required String text,
    required String id,
  }) = _ChatMessageInfo;

  factory ChatMessageInfo.fromJson(Map<String, dynamic> json) => _$ChatMessageInfoFromJson(json);
}
