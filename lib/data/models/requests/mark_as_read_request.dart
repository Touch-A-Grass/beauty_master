import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_as_read_request.freezed.dart';
part 'mark_as_read_request.g.dart';

@freezed
class MarkAsReadRequest with _$MarkAsReadRequest {
  const factory MarkAsReadRequest({required List<String> messageIds}) = _MarkAsReadRequest;

  factory MarkAsReadRequest.fromJson(Map<String, dynamic> json) => _$MarkAsReadRequestFromJson(json);
}
