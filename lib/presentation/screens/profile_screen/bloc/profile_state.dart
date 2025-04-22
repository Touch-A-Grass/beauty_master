part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({StaffProfile? profile, @Default(false) bool isUpdatingUser}) = _ProfileState;
}
