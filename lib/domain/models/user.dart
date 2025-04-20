import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({required String id, required String name, required String phoneNumber, String? photo}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get initials {
    final names = name.trim().split(' ');
    return names.where((e) => e.isNotEmpty).map((e) => e.substring(0, 1)).join('');
  }
}
