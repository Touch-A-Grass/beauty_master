import 'package:beauty_master/data/api/interceptors/auth_interceptor.dart';
import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio create(AuthStorage authStorage) {
    final dio = Dio();
    final retryDio = Dio();

    dio.interceptors.addAll([
      AuthInterceptor(authStorage: authStorage, retryDio: retryDio),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}
