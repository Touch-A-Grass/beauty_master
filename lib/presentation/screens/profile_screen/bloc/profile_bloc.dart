import 'package:beauty_master/domain/models/staff_profile.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:beauty_master/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with SubscriptionBloc {
  final AuthRepository _authRepository;

  ProfileBloc(this._authRepository) : super(const ProfileState()) {
    on<_Started>((event, emit) {
      add(ProfileEvent.userRequested());
    });

    on<_UserRequested>((event, emit) async {
      try {
        await _authRepository.fetchProfile();
      } catch (_) {}
    });

    on<_UserChanged>((event, emit) {
      emit(state.copyWith(profile: event.profile));
    });

    subscribe(_authRepository.watchProfile(), (profile) {
      add(ProfileEvent.userChanged(profile));
    });
  }
}
