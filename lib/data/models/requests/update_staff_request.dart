import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_staff_request.freezed.dart';

part 'update_staff_request.g.dart';

@freezed
class UpdateStaffRequest with _$UpdateStaffRequest {
  const factory UpdateStaffRequest({required String staffId, String? name, String? photo}) = _UpdateStaffRequest;

  factory UpdateStaffRequest.fromJson(Map<String, dynamic> json) => _$UpdateStaffRequestFromJson(json);
}
