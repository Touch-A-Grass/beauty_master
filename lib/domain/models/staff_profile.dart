import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_profile.freezed.dart';

part 'staff_profile.g.dart';

@JsonEnum()
enum StaffRole {
  @JsonValue('Manager')
  manager,
  @JsonValue('Master')
  master,
}

@freezed
class StaffProfile with _$StaffProfile {
  const StaffProfile._();

  const factory StaffProfile({
    required String id,
    required String name,
    required String phoneNumber,
    required StaffRole role,
    String? photo,
  }) = _StaffProfile;

  factory StaffProfile.fromJson(Map<String, dynamic> json) => _$StaffProfileFromJson(json);


  String get initials {
    final names = name.trim().split(' ');
    return names.where((e) => e.isNotEmpty).map((e) => e.substring(0, 1)).join('');
  }
}
