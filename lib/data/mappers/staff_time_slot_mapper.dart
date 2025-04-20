import 'package:beauty_master/data/models/dto/staff_time_slot_dto.dart';
import 'package:beauty_master/data/models/dto/time_interval_dto.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/domain/models/time_interval.dart';

class StaffTimeSlotMapper {
  const StaffTimeSlotMapper._();

  static StaffTimeSlot fromDto(StaffTimeSlotDto dto) => StaffTimeSlot(
    id: dto.id,
    date: dto.date,
    intervals: dto.intervals.map((e) => _timeIntervalFromDto(e, dto.date)).toList(),
  );

  static TimeInterval _timeIntervalFromDto(TimeIntervalDto dto, DateTime date) {
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
