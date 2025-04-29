import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_log_dto.freezed.dart';
part 'chat_log_dto.g.dart';

@freezed
class ChatLogDto with _$ChatLogDto {
  const factory ChatLogDto({
    required String type,
    String? senderId,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isRead,
    String? text,
    String? id,
  }) = _ChatLogDto;

  factory ChatLogDto.fromJson(Map<String, dynamic> json) => _$ChatLogDtoFromJson(json);
}
