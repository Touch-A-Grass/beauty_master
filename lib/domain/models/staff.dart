import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const Staff._();

  const factory Staff({
    required String id,
    required String name,
    required String phoneNumber,
    @Default([]) List<String> services,
    String? photo,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);

  String get initials {
    final names = name.trim().split(' ');
    return names.where((e) => e.isNotEmpty).map((e) => e.substring(0, 1)).join('');
  }
}
