import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

part 'auth.g.dart';

@freezed
class Auth with _$Auth {
  const factory Auth({
    required String token,
    required String refreshToken,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}
