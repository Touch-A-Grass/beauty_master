import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'service.freezed.dart';
part 'service.g.dart';


@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String name,
    @Default('') String description,
    @ServiceDurationConverter() Duration? duration,
    double? price,
    String? photo,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
}

class ServiceDurationConverter extends JsonConverter<Duration, String> {
  const ServiceDurationConverter();

  @override
  Duration fromJson(String json) {
    final format = DateFormat('HH:mm:ss');
    final date = format.parse(json);
    return Duration(hours: date.hour, minutes: date.minute, seconds: date.second);
  }

  @override
  String toJson(Duration object) {
    final format = DateFormat('HH:mm:ss');
    final date = DateTime(0, 0, 0, object.inHours, object.inMinutes, object.inSeconds);
    return format.format(date);
  }
}
