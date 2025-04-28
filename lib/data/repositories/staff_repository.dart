import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/mappers/staff_time_slot_mapper.dart';
import 'package:beauty_master/data/models/dto/time_slot_interval_dto.dart';
import 'package:beauty_master/data/models/requests/add_time_slot_request.dart';
import 'package:beauty_master/data/models/requests/edit_time_slot_request.dart';
import 'package:beauty_master/data/util/server_date_util.dart';
import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';
import 'package:intl/intl.dart';

class StaffRepositoryImpl implements StaffRepository {
  final BeautyClient _api;

  StaffRepositoryImpl(this._api);

  @override
  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId}) async {
    final dto = await _api.getVenueStaffTimeSlots(staffId: staffId, venueId: venueId);
    return dto.map((e) => StaffTimeSlotMapper.fromDto(e)).toList();
  }

  @override
  Future<List<Venue>> getStaffVenues() async {
    return _api.getStaffOrganizationVenues();
  }

  @override
  Future<void> changeTimeSlot({
    required DateTime date,
    required List<TimeInterval> intervals,
    required DaySchedule? schedule,
    required String staffId,
    required String venueId,
  }) async {
    final dateFormat = DateFormat('HH:mm');
    final intervalsDto =
        intervals
            .map((e) => TimeSlotIntervalDto(startTime: dateFormat.format(e.start), endTime: dateFormat.format(e.end)))
            .toList();

    if (schedule == null) {
      await _api.addStaffTimeSlot(
        AddTimeSlotRequest(date: date.serverDateOnly, intervals: intervalsDto, staffId: staffId, venueId: venueId),
      );
    } else {
      await _api.editStaffTimeSlot(
        EditTimeSlotRequest(date: date.serverDateOnly, timeSlotId: schedule.timeSlotId!, intervals: intervalsDto, staffId: staffId),
      );
    }
  }
}
