part of 'time_slot_edit_bloc.dart';

@freezed
class TimeSlotEditEvent with _$TimeSlotEditEvent {
  const factory TimeSlotEditEvent.started() = _Started;

  const factory TimeSlotEditEvent.venuesRequested() = _VenuesReqeusted;

  const factory TimeSlotEditEvent.reset(FreeTimeWorkloadTimeSlot? timeSlot) = _Reset;

  const factory TimeSlotEditEvent.venueSelected(Venue? venue) = _VenueSelected;

  const factory TimeSlotEditEvent.loadCurrentVenueRequested() = _LoadCurrentVenueRequested;
}
