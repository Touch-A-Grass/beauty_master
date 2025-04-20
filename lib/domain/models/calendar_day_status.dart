import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum CalendarDayStatus {
  @JsonValue('noOrders')
  noOrders,
  @JsonValue('newOrders')
  newOrders,
  @JsonValue('approved')
  approved,
  @JsonValue('completed')
  completed,
}

typedef CalendarMonthStatus = Map<int, CalendarDayStatus>;

extension CalendarMonthStatusExtension on CalendarMonthStatus {
  CalendarDayStatus getDayStatus(int day) => this[day] ?? CalendarDayStatus.noOrders;
}
