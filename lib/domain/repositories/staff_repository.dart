import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/venue.dart';

abstract interface class StaffRepository {
  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId});

  Future<void> changeTimeSlot({
    required DateTime date,
    required List<TimeInterval> intervals,
    required String venueId,
    required DaySchedule? schedule,
    required String staffId,
  });

  Future<List<Venue>> getStaffVenues();
}
