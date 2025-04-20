import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

part 'app_error.g.dart';

@freezed
class AppError with _$AppError {
  const factory AppError({required String message}) = _AppError;

  factory AppError.fromJson(Map<String, dynamic> json) => _$AppErrorFromJson(json);

  factory AppError.fromObject(dynamic e) {
    if (e is DioException) {
      return AppError(message: e.response?.data['error']?['message'] ?? 'Something went wrong');
    }
    return AppError(message: e.toString());
  }
}
