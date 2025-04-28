import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/workload_order_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workload_time_slot.freezed.dart';
part 'workload_time_slot.g.dart';

@freezed
sealed class WorkloadTimeSlot with _$WorkloadTimeSlot {
  const factory WorkloadTimeSlot.freeTime({
    required String id,
    required TimeInterval timeInterval,
    required String venueId,
  }) = FreeTimeWorkloadTimeSlot;

  const factory WorkloadTimeSlot.record({
    required String id,
    required WorkloadOrderInfo recordInfo,
    required TimeInterval timeInterval,
  }) = RecordWorkloadTimeSlot;

  factory WorkloadTimeSlot.fromJson(Map<String, dynamic> json) => _$WorkloadTimeSlotFromJson(json);
}
