import 'package:beauty_master/data/storage/base/persistent_stream_storage.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';

class ProfileStorage extends PersistentStreamStorage<StaffProfile?> {
  ProfileStorage({required super.secureStorage})
    : super(
        initialValue: null,
        fromJson: StaffProfile.fromJson,
        toJson: (value) => value?.toJson() ?? {},
        key: 'staff_profile',
      );

  StaffProfile get profile => value!;
}
