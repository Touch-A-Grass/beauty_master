part of 'time_slot_edit_bloc.dart';

@freezed
class TimeSlotEditState with _$TimeSlotEditState {
  const TimeSlotEditState._();

  const factory TimeSlotEditState({
    @Default([]) List<Venue> venues,
    required FreeTimeWorkloadTimeSlot? timeSlot,
    Venue? selectedVenue,
    @Default(true) bool isLoadingVenues,
    @Default(false) bool isLoadingCurrentVenue,
  }) = _TimeSlotEditState;

  bool get isLoading => isLoadingVenues || isLoadingCurrentVenue;
}
