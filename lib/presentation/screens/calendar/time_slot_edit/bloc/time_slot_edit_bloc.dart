import 'package:beauty_master/domain/models/venue.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';
import 'package:beauty_master/domain/repositories/venue_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_edit_bloc.freezed.dart';
part 'time_slot_edit_event.dart';
part 'time_slot_edit_state.dart';

class TimeSlotEditBloc extends Bloc<TimeSlotEditEvent, TimeSlotEditState> {
  final StaffRepository _staffRepository;
  final VenueRepository _venueRepository;

  TimeSlotEditBloc(this._staffRepository, this._venueRepository, {required FreeTimeWorkloadTimeSlot? timeSlot})
    : super(TimeSlotEditState(timeSlot: timeSlot)) {
    on<_Started>((event, emit) {
      add(TimeSlotEditEvent.venuesRequested());
      add(TimeSlotEditEvent.loadCurrentVenueRequested());
    });
    on<_Reset>((event, emit) {
      emit(
        state.copyWith(timeSlot: event.timeSlot, selectedVenue: event.timeSlot != null ? null : state.selectedVenue),
      );
      add(TimeSlotEditEvent.started());
    });
    on<_VenuesReqeusted>((event, emit) async {
      emit(state.copyWith(isLoadingVenues: true));
      try {
        final venues = await _staffRepository.getStaffVenues();
        emit(state.copyWith(venues: venues));
      } catch (e, t) {
        debugPrintStack(stackTrace: t);
      }
      emit(state.copyWith(isLoadingVenues: false));
    });
    on<_LoadCurrentVenueRequested>((event, emit) async {
      final timeSlot = state.timeSlot;
      if (timeSlot == null) return;
      emit(state.copyWith(isLoadingVenues: true));
      try {
        final venue = await _venueRepository.getVenue(timeSlot.venueId);
        emit(state.copyWith(selectedVenue: venue));
      } catch (e, t) {
        debugPrintStack(stackTrace: t);
      }
      emit(state.copyWith(isLoadingVenues: false));
    });
    on<_VenueSelected>((event, emit) => emit(state.copyWith(selectedVenue: event.venue)));
  }
}
