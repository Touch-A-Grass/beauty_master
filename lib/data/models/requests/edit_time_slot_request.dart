import 'package:beauty_master/data/models/dto/time_slot_interval_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_time_slot_request.freezed.dart';
part 'edit_time_slot_request.g.dart';

@freezed
class EditTimeSlotRequest with _$EditTimeSlotRequest {
  const factory EditTimeSlotRequest({
    required String date,
    required String timeSlotId,
    required List<TimeSlotIntervalDto> intervals,
    required String staffId,
  }) = _EditTimeSlotRequest;

  factory EditTimeSlotRequest.fromJson(Map<String, dynamic> json) => _$EditTimeSlotRequestFromJson(json);
}
