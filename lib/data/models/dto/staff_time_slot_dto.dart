import 'package:beauty_master/data/models/dto/time_interval_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_time_slot_dto.freezed.dart';
part 'staff_time_slot_dto.g.dart';

@freezed
class StaffTimeSlotDto with _$StaffTimeSlotDto {
  const factory StaffTimeSlotDto({
    required String id,
    required DateTime date,
    @Default([]) List<TimeIntervalDto> intervals,
  }) = _StaffTimeSlotDto;

  factory StaffTimeSlotDto.fromJson(Map<String, dynamic> json) => _$StaffTimeSlotDtoFromJson(json);
}
