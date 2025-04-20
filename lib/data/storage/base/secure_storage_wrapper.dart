import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageWrapper<T> {
  final FlutterSecureStorage storage;
  final String key;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  SecureStorageWrapper({
    required this.storage,
    required this.key,
    required this.fromJson,
    required this.toJson,
  });

  Future<T?> get() async {
    try {
      final value = await storage.read(key: key);
      return value == null ? null : fromJson(jsonDecode(value));
    } catch (_) {
      return null;
    }
  }

  Future<void> set(T value) async {
    await storage.write(key: key, value: jsonEncode(toJson(value)));
  }

  Future<void> delete() async {
    await storage.delete(key: key);
  }
}
