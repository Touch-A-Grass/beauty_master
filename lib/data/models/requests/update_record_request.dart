import 'package:beauty_master/domain/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_record_request.freezed.dart';
part 'update_record_request.g.dart';

@freezed
class UpdateRecordRequest with _$UpdateRecordRequest {
  const factory UpdateRecordRequest({
    required String recordId,
    OrderStatus? status,
    String? comment,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
  }) = _UpdateRecordRequest;

  factory UpdateRecordRequest.fromJson(Map<String, dynamic> json) => _$UpdateRecordRequestFromJson(json);
}
