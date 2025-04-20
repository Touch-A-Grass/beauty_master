import 'package:beauty_master/data/api/beauty_client.dart';
import 'package:beauty_master/data/mappers/staff_time_slot_mapper.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final BeautyClient _api;

  StaffRepositoryImpl(this._api);

  @override
  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId}) async {
    final dto = await _api.getVenueStaffTimeSlots(staffId: staffId, venueId: venueId);
    return dto.map((e) => StaffTimeSlotMapper.fromDto(e)).toList();
  }
}
