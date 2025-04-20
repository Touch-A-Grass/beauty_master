import 'package:beauty_master/domain/models/app_error.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.phone()) {
    on<_PhoneEntered>((event, emit) async {
      try {
        emit(AuthState.telegram(event.phone));
        await _authRepository.sendPhone(event.phone);
        emit(AuthState.code(event.phone, codeRetrievedTime: DateTime.now()));
      } catch (_) {
        emit(const AuthState.phone());
      }
    });

    on<_ResendCodeRequested>((event, emit) async {
      if (state is! AuthCodeState) return;
      final codeState = state as AuthCodeState;
      try {
        emit(codeState.copyWith(isLoading: true));
        await _authRepository.sendPhone(codeState.phone);
        emit(AuthState.code(codeState.phone, codeRetrievedTime: DateTime.now()));
      } catch (_) {
        emit(const AuthState.phone());
      }
    });

    on<_CodeEntered>((event, emit) async {
      if (state is! AuthCodeState) return;
      final codeState = state as AuthCodeState;
      emit(AuthState.code(codeState.phone, isLoading: true, codeRetrievedTime: codeState.codeRetrievedTime));
      try {
        await _authRepository.sendCode(codeState.phone, event.code);
        emit(AuthState.code(
          codeState.phone,
          isLoading: false,
          codeRetrievedTime: codeState.codeRetrievedTime,
          isLoggedIn: true,
        ));
      } catch (e) {
        emit(
          AuthState.code(
            codeState.phone,
            isLoading: false,
            error: AppError.fromObject(e),
            codeRetrievedTime: codeState.codeRetrievedTime,
          ),
        );
      }
    });

    on<_ChangePhoneRequested>((event, emit) {
      emit(const AuthState.phone());
    });
  }
}
