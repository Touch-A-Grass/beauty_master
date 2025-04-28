import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_schedule.freezed.dart';
part 'day_schedule.g.dart';

@freezed
class DaySchedule with _$DaySchedule {
  const factory DaySchedule({
    String? timeSlotId,
    @Default([]) List<WorkloadTimeSlot> workload,
    required String venueId,
  }) = _DaySchedule;

  factory DaySchedule.fromJson(Map<String, dynamic> json) => _$DayScheduleFromJson(json);
}
