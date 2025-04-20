part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.phoneEntered(String phone) = _PhoneEntered;

  const factory AuthEvent.codeEntered(String code) = _CodeEntered;

  const factory AuthEvent.changePhoneRequested() = _ChangePhoneRequested;

  const factory AuthEvent.resendCodeRequested() = _ResendCodeRequested;
}
