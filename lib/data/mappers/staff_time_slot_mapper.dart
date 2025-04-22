import 'package:beauty_master/data/mappers/time_interval_mapper.dart';
import 'package:beauty_master/data/models/dto/staff_time_slot_dto.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';

class StaffTimeSlotMapper {
  const StaffTimeSlotMapper._();

  static StaffTimeSlot fromDto(StaffTimeSlotDto dto) => StaffTimeSlot(
    id: dto.id,
    date: dto.date,
    intervals: dto.intervals.map((e) => TimeIntervalMapper.fromDto(e, dto.date)).toList(),
  );
}
