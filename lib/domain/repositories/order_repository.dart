import 'package:beauty_master/data/event/order_chat_unread_count_changed_event_bus.dart';
import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_live_event.dart';

abstract interface class OrderRepository {
  Future<List<Order>> getOrders({required int limit, required int offset, DateTime? date});

  Future<Order> getOrder(String id);

  Future<CalendarMonthStatus> getWorkload(DateTime month);

  Future<void> approveOrder(String id);

  Future<void> discardOrder({required String id, required String reason});

  Future<void> completeOrder(String id);

  Future<void> changeOrderTime({required String id, required DateTime time, required DateTime endTime});

  Stream<Order> watchOrderChangedEvent();

  Future<List<DaySchedule>> getDaySchedule(DateTime date);

  Future<List<ChatEventInfo>> getChatEvents(String orderId);

  Future<void> sendChatMessage({required String orderId, required String message, required String messageId});

  Stream<ChatLiveEvent> watchOrderChatEvents(String orderId);

  Future<void> markAsRead({required String orderId, required List<String> messageIds});

  Stream<int> watchOrderChatUnreadCount(String orderId);

  Stream<OrderChatUnreadCountChangedEvent> watchOrderChatUnreadCountAll();
}
