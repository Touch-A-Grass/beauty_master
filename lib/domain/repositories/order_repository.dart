import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/order.dart';

abstract interface class OrderRepository {
  Future<List<Order>> getOrders({required int limit, required int offset, DateTime? date});

  Future<Order> getOrder(String id);

  Future<CalendarMonthStatus> getWorkload(DateTime month);

  Future<void> approveOrder(String id);

  Future<void> discardOrder({required String id, required String reason});

  Stream<Order> watchOrderChangedEvent();
}
