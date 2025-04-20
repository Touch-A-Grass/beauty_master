import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_phone_request.freezed.dart';
part 'send_phone_request.g.dart';

@freezed
class SendPhoneRequest with _$SendPhoneRequest {
  const factory SendPhoneRequest({required String phoneNumber}) = _SendPhoneRequest;

  factory SendPhoneRequest.fromJson(Map<String, dynamic> json) => _$SendPhoneRequestFromJson(json);
}
