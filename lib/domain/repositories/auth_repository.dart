import 'dart:typed_data';

import 'package:beauty_master/domain/models/auth.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';

abstract interface class AuthRepository {
  Future<void> sendPhone(String phone);

  Future<Auth> sendCode(String phone, String code);

  Stream<Auth?> watchAuth();

  Auth? getAuth();

  Future<void> logout();

  Future<StaffProfile> fetchProfile();

  Future<StaffProfile> getProfile();

  Stream<StaffProfile?> watchProfile();

  Future<void> updateName(String name);

  Future<void> updatePhoto(Uint8List photo);

  Future<void> sendFirebaseToken(String token);
}
