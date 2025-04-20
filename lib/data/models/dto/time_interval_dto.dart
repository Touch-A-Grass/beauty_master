import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_interval_dto.freezed.dart';
part 'time_interval_dto.g.dart';

@freezed
class TimeIntervalDto with _$TimeIntervalDto {
  const TimeIntervalDto._();

  const factory TimeIntervalDto({required String start, required String end}) = _TimeIntervalDto;

  factory TimeIntervalDto.fromJson(Map<String, dynamic> json) => _$TimeIntervalDtoFromJson(json);

  Duration get startDuration {
    final str = start.split(':');
    return Duration(hours: int.parse(str[0]), minutes: int.parse(str[1]));
  }

  Duration get endDuration {
    final str = end.split(':');
    return Duration(hours: int.parse(str[0]), minutes: int.parse(str[1]));
  }
}
