import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';

class ChangeTimeSlotUseCase {
  final AuthRepository _authRepository;
  final StaffRepository _staffRepository;

  ChangeTimeSlotUseCase(this._authRepository, this._staffRepository);

  Future<void> execute({
    required DateTime date,
    required List<TimeInterval> intervals,
    required DaySchedule? schedule,
    required String venueId,
  }) async {
    final staff = await _authRepository.getProfile();
    await _staffRepository.changeTimeSlot(
      date: date,
      intervals: intervals,
      schedule: schedule,
      staffId: staff.id,
      venueId: venueId,
    );
  }
}
