part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.phone() = AuthPhoneState;

  const factory AuthState.code(
    String phone, {
    @Default(false) bool isLoading,
    AppError? error,
    required DateTime codeRetrievedTime,
    @Default(false) bool isLoggedIn,
  }) = AuthCodeState;

  const factory AuthState.telegram(String phone) = AuthTelegramState;
}
