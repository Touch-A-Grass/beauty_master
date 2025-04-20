import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_time_slot.freezed.dart';
part 'staff_time_slot.g.dart';

@freezed
class StaffTimeSlot with _$StaffTimeSlot {
  const factory StaffTimeSlot({required String id, required DateTime date, @Default([]) List<TimeInterval> intervals}) =
      _StaffTimeSlot;

  factory StaffTimeSlot.fromJson(Map<String, dynamic> json) => _$StaffTimeSlotFromJson(json);
}
