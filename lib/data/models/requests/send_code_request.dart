import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_code_request.freezed.dart';
part 'send_code_request.g.dart';

@freezed
class SendCodeRequest with _$SendCodeRequest {
  const factory SendCodeRequest({
    required String phoneNumber,
    required String code,
  }) = _SendCodeRequest;

  factory SendCodeRequest.fromJson(Map<String, dynamic> json) => _$SendCodeRequestFromJson(json);
}
