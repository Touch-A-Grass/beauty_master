part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.userRequested() = _UserRequested;

  const factory ProfileEvent.userChanged(StaffProfile? profile) = _UserChanged;

  const factory ProfileEvent.updateUserRequested(String name) = _UpdateUserRequested;

  const factory ProfileEvent.updatePhotoRequested(Uint8List photo) = _UpdatePhotoRequested;

  const factory ProfileEvent.logoutRequested() = _LogoutRequested;
}
