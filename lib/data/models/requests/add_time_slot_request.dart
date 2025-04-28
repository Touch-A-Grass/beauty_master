import 'package:beauty_master/data/models/dto/time_slot_interval_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_time_slot_request.freezed.dart';
part 'add_time_slot_request.g.dart';

@freezed
class AddTimeSlotRequest with _$AddTimeSlotRequest {
  const factory AddTimeSlotRequest({
    required String date,
    required String venueId,
    required List<TimeSlotIntervalDto> intervals,
    required String staffId,
  }) = _AddTimeSlotRequest;

  factory AddTimeSlotRequest.fromJson(Map<String, dynamic> json) => _$AddTimeSlotRequestFromJson(json);
}
