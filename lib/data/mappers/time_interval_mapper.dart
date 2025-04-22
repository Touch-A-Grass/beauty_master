import 'package:beauty_master/data/models/dto/time_interval_dto.dart';
import 'package:beauty_master/domain/models/time_interval.dart';

class TimeIntervalMapper {
  const TimeIntervalMapper._();

  static TimeInterval fromDto(TimeIntervalDto dto, DateTime date) {
    final startDuration = dto.startDuration;
    var endDuration = dto.endDuration;

    if (startDuration >= endDuration) {
      endDuration += Duration(days: 1);
    }

    return TimeInterval(
      start: DateTime(date.year, date.month, date.day).add(startDuration),
      end: DateTime(date.year, date.month, date.day).add(endDuration),
    );
  }
}
