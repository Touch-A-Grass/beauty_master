import 'dart:convert';
import 'dart:typed_data';

import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/models/requests/send_code_request.dart';
import 'package:beauty_master/data/models/requests/send_firebase_token_request.dart';
import 'package:beauty_master/data/models/requests/send_phone_request.dart';
import 'package:beauty_master/data/models/requests/update_staff_request.dart';
import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:beauty_master/data/storage/profile_storage.dart';
import 'package:beauty_master/domain/models/auth.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BeautyClient _api;
  final AuthStorage _authStorage;
  final ProfileStorage _profileStorage;

  AuthRepositoryImpl(this._api, this._authStorage, this._profileStorage);

  @override
  Future<Auth> sendCode(String phone, String code) async {
    final auth = await _api.sendCode(SendCodeRequest(phoneNumber: phone, code: code));
    _authStorage.update(auth);
    await fetchProfile();
    return auth;
  }

  @override
  Future<void> sendPhone(String phone) async {
    return _api.sendPhone(SendPhoneRequest(phoneNumber: phone));
  }

  @override
  Stream<Auth?> watchAuth() => _authStorage.stream;

  @override
  Auth? getAuth() => _authStorage.value;

  @override
  Future<void> logout() async {
    _authStorage.update(null);
  }

  @override
  Future<StaffProfile> fetchProfile() async {
    final profile = await _api.getProfile();
    _profileStorage.update(profile);
    return profile;
  }

  @override
  Future<StaffProfile> getProfile() async {
    return _profileStorage.value ?? await fetchProfile();
  }

  @override
  Stream<StaffProfile?> watchProfile() => _profileStorage.stream;

  @override
  Future<void> updateName(String name) async {
    await _api.updateStaff(UpdateStaffRequest(staffId: (await getProfile()).id, name: name));
  }

  @override
  Future<void> updatePhoto(Uint8List photo) async {
    await _api.updateStaff(UpdateStaffRequest(staffId: (await getProfile()).id, photo: base64Encode(photo)));
  }

  @override
  Future<void> sendFirebaseToken(String token) {
    return _api.sendFirebaseToken(SendFirebaseTokenRequest(token: token));
  }
}
