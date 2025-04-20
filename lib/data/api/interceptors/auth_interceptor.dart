import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:beauty_master/domain/models/auth.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final AuthStorage authStorage;
  final Dio retryDio;

  AuthInterceptor({required this.authStorage, required this.retryDio});

  bool refreshing = false;
  final failedRequests = [];

  void _addAuthorizationHeader(RequestOptions options) {
    final token = authStorage.value?.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _addAuthorizationHeader(options);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    failedRequests.add({'err': err, 'handler': handler});

    if (refreshing) {
      return;
    }

    final data = await refreshToken();
    if (data.statusCode != 200) {
      return handler.next(err);
    }
  }

  Future<Response> refreshToken() async {
    final refreshToken = authStorage.value?.refreshToken;
    final response = await retryDio.post('/user/refresh-token', data: {'refresh_token': refreshToken});

    if (response.statusCode == 200) {
      await authStorage.update(Auth.fromJson(response.data));
      await _retry(response.data['data']['accessToken']);
      refreshing = false;
    }
    return response;
  }

  Future<void> _retry(RequestOptions requestOptions) async {
    for (var i = 0; i < failedRequests.length; i++) {
      RequestOptions requestOptions = failedRequests[i]['err'].requestOptions;

      _addAuthorizationHeader(requestOptions);

      await retryDio.fetch(requestOptions).then(
        failedRequests[i]['handler'].resolve,
        onError: (error) async {
          failedRequests[i]['handler'].reject(error);
        },
      );
    }

    failedRequests.clear();
  }
}
