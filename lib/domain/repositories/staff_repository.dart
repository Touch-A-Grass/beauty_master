import 'package:beauty_master/domain/models/staff_time_slot.dart';

abstract interface class StaffRepository {
  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId});
}
