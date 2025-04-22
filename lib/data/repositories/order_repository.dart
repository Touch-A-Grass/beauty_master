import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/event/order_changed_event_bus.dart';
import 'package:beauty_master/data/mappers/time_interval_mapper.dart';
import 'package:beauty_master/data/models/requests/update_record_request.dart';
import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/workload_order_info.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:uuid/uuid.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;
  final OrderChangedEventBus _orderChangedEventBus;

  OrderRepositoryImpl(this._client, this._orderChangedEventBus);

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
  Future<DaySchedule> getDaySchedule(DateTime date) async {
    final year = date.year;
    final monthNumber = date.month;
    final day = date.day;
    final dto = await _client.getDaySchedule(year, monthNumber, day);
    return DaySchedule(
      timeSlotId: dto.timeSlotId,
      workload:
          dto.workload
              .map(
                (e) => switch (e.recordInfo) {
                  null => WorkloadTimeSlot.freeTime(
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
    );
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
}
