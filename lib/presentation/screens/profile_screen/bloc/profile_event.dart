part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.userRequested() = _UserRequested;

  const factory ProfileEvent.userChanged(StaffProfile? profile) = _UserChanged;
}
