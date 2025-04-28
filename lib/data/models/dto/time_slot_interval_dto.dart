import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_interval_dto.freezed.dart';
part 'time_slot_interval_dto.g.dart';

@freezed
class TimeSlotIntervalDto with _$TimeSlotIntervalDto {
  const factory TimeSlotIntervalDto({required String startTime, required String endTime}) = _TimeSlotIntervalDto;

  factory TimeSlotIntervalDto.fromJson(Map<String, dynamic> json) => _$TimeSlotIntervalDtoFromJson(json);
}
