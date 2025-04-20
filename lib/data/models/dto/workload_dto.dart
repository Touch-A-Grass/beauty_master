import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workload_dto.freezed.dart';
part 'workload_dto.g.dart';

@freezed
class WorkloadDto with _$WorkloadDto {
  const factory WorkloadDto({required int day, required CalendarDayStatus status}) = _WorkloadDto;

  factory WorkloadDto.fromJson(Map<String, dynamic> json) => _$WorkloadDtoFromJson(json);
}
