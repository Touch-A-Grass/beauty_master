import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/event/order_changed_event_bus.dart';
import 'package:beauty_master/data/event/order_chat_unread_count_changed_event_bus.dart';
import 'package:beauty_master/data/mappers/time_interval_mapper.dart';
import 'package:beauty_master/data/models/requests/mark_as_read_request.dart';
import 'package:beauty_master/data/models/requests/send_message_request.dart';
import 'package:beauty_master/data/models/requests/update_record_request.dart';
import 'package:beauty_master/data/websocket_api/websocket_api.dart';
import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/workload_order_info.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/features/chat/data/mappers/chat_event_mapper.dart';
import 'package:beauty_master/features/chat/data/models/messages/order_chat_socket_message.dart';
import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_live_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message_info.dart';
import 'package:uuid/uuid.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;
  final WebsocketApi _websocketApi;
  final OrderChangedEventBus _orderChangedEventBus;
  final OrderChatUnreadCountChangedEventBus _orderChatUnreadCountChangedEventBus;

  OrderRepositoryImpl(
    this._client,
    this._websocketApi,
    this._orderChangedEventBus,
    this._orderChatUnreadCountChangedEventBus,
  );

  @override
  Future<Order> getOrder(String id) async {
    final order = await _client.getOrder(id);
    _orderChangedEventBus.emit(order);
    return order;
  }

  @override
  Future<List<Order>> getOrders({required int limit, required int offset, DateTime? date}) =>
      _client.getOrders(limit: limit, offset: offset, date: date);

  @override
  Stream<Order> watchOrderChangedEvent() => _orderChangedEventBus.stream;

  @override
  Future<CalendarMonthStatus> getWorkload(DateTime month) async {
    final year = month.year;
    final monthNumber = month.month;
    final workloads = await _client.getWorkload(year, monthNumber);
    final CalendarMonthStatus monthStatus = {};
    for (final workload in workloads) {
      monthStatus[workload.day] = workload.status;
    }
    return monthStatus;
  }

  @override
  Future<List<DaySchedule>> getDaySchedule(DateTime date) async {
    final year = date.year;
    final monthNumber = date.month;
    final day = date.day;
    final response = await _client.getDaySchedule(year, monthNumber, day);
    return response
        .map(
          (dto) => DaySchedule(
            timeSlotId: dto.timeSlotId,
            venueId: dto.venueId,
            workload:
                dto.workload
                    .map(
                      (e) => switch (e.recordInfo) {
                        null => WorkloadTimeSlot.freeTime(
                          venueId: dto.venueId,
                          id: const Uuid().v4(),
                          timeInterval: TimeIntervalMapper.fromDto(e.interval, date),
                        ),
                        WorkloadOrderInfo recordInfo => WorkloadTimeSlot.record(
                          id: const Uuid().v4(),
                          timeInterval: TimeIntervalMapper.fromDto(e.interval, date),
                          recordInfo: recordInfo,
                        ),
                      },
                    )
                    .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<void> approveOrder(String id) async {
    await _client.updateOrder(UpdateRecordRequest(recordId: id, status: OrderStatus.approved));
  }

  @override
  Future<void> discardOrder({required String id, required String reason}) {
    return _client.updateOrder(UpdateRecordRequest(recordId: id, status: OrderStatus.discarded, comment: reason));
  }

  @override
  Future<void> completeOrder(String id) {
    return _client.updateOrder(UpdateRecordRequest(recordId: id, status: OrderStatus.completed));
  }

  @override
  Future<void> changeOrderTime({required String id, required DateTime time, required DateTime endTime}) {
    return _client.updateOrder(UpdateRecordRequest(recordId: id, startTimestamp: time, endTimestamp: endTime));
  }

  @override
  Future<List<ChatEventInfo>> getChatEvents(String orderId) async {
    final eventsDto = await _client.getOrderMessages(orderId);
    return eventsDto.map((e) => ChatEventInfoMapper.fromDto(e)).nonNulls.toList();
  }

  @override
  Future<void> sendChatMessage({required String orderId, required String message, required String messageId}) {
    return _client.sendOrderMessage(orderId, SendMessageRequest(text: message, messageId: messageId));
  }

  @override
  Future<void> markAsRead({required String orderId, required List<String> messageIds}) async {
    await _client.markAsRead(orderId, MarkAsReadRequest(messageIds: messageIds));
    _orderChatUnreadCountChangedEventBus.emit(OrderChatUnreadCountChangedEvent(orderId: orderId, count: 0));
  }

  @override
  Stream<ChatLiveEvent> watchOrderChatEvents(String orderId) {
    return _websocketApi
        .connectToOrderChat(orderId)
        .map(
          (e) => switch (e) {
            MessageReceivedOrderChatSocketMessage message => ChatLiveEvent.eventReceived(
              ChatEventInfo.message(
                ChatMessageInfo(
                  senderId: message.senderId,
                  createdAt: message.createdAt.toLocal(),
                  readAt: null,
                  isRead: false,
                  text: message.message,
                  id: message.messageId,
                ),
              ),
            ),
            MessageReadOrderChatSocketMessage e => ChatLiveEvent.messageRead(e.messageId),
          },
        );
  }

  @override
  Stream<int> watchOrderChatUnreadCount(String orderId) =>
      _orderChatUnreadCountChangedEventBus.stream.where((e) => e.orderId == orderId).map((e) => e.count);

  @override
  Stream<OrderChatUnreadCountChangedEvent> watchOrderChatUnreadCountAll() =>
      _orderChatUnreadCountChangedEventBus.stream;
}
