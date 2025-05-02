import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_firebase_token_request.freezed.dart';
part 'send_firebase_token_request.g.dart';

@freezed
class SendFirebaseTokenRequest with _$SendFirebaseTokenRequest {
  const factory SendFirebaseTokenRequest({required String token}) = _SendFirebaseTokenRequest;

  factory SendFirebaseTokenRequest.fromJson(Map<String, dynamic> json) => _$SendFirebaseTokenRequestFromJson(json);
}
