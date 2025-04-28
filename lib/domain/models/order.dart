import 'package:beauty_master/domain/models/order_review.dart';
import 'package:beauty_master/domain/models/service.dart';
import 'package:beauty_master/domain/models/staff.dart';
import 'package:beauty_master/domain/models/user.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    required String id,
    required Staff? staff,
    required Venue venue,
    required Service service,
    User? user,
    required DateTime startTimestamp,
    required DateTime endTimestamp,
    @Default('') String comment,
    @Default(OrderStatus.pending) OrderStatus status,
    OrderReview? review,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@JsonEnum()
enum OrderStatus {
  @JsonValue('Discarded')
  discarded,
  @JsonValue('Pending')
  pending,
  @JsonValue('Approved')
  approved,
  @JsonValue('Completed')
  completed,
}
