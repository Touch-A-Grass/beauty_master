import 'package:beauty_master/domain/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_status_log.freezed.dart';
part 'chat_status_log.g.dart';

@freezed
sealed class ChatStatusLog with _$ChatStatusLog {
  const factory ChatStatusLog.orderStatus({required String id, required String text, required OrderStatus status}) =
      OrderStatusChatStatusLog;

  const factory ChatStatusLog.misc({required String id, required String text, required String type}) =
      MiscChatStatusLog;

  factory ChatStatusLog.fromJson(Map<String, dynamic> json) => _$ChatStatusLogFromJson(json);
}
