import 'package:beauty_master/domain/models/service.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    required Venue venue,
    Service? service,
    String? masterId,
    DateTime? timeSlot,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
