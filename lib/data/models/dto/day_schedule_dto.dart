import 'package:beauty_master/data/models/dto/time_interval_dto.dart';
import 'package:beauty_master/domain/models/workload_order_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_schedule_dto.freezed.dart';
part 'day_schedule_dto.g.dart';

@freezed
class DayScheduleDto with _$DayScheduleDto {
  const factory DayScheduleDto({String? timeSlotId, @Default([]) List<WorkloadTimeSlotDto> workload}) = _DayScheduleDto;

  factory DayScheduleDto.fromJson(Map<String, dynamic> json) => _$DayScheduleDtoFromJson(json);
}

@freezed
class WorkloadTimeSlotDto with _$WorkloadTimeSlotDto {
  const factory WorkloadTimeSlotDto({
    WorkloadOrderInfo? recordInfo,
    required String type,
    required TimeIntervalDto interval,
  }) = _WorkloadTimeSlotDto;

  factory WorkloadTimeSlotDto.fromJson(Map<String, dynamic> json) => _$WorkloadTimeSlotDtoFromJson(json);
}
