import 'package:beauty_master/domain/models/app_error.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/domain/repositories/staff_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_details_bloc.freezed.dart';
part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderRepository _orderRepository;
  final StaffRepository _staffRepository;
  final AuthRepository _authRepository;

  OrderDetailsBloc(this._orderRepository, this._staffRepository, this._authRepository, {required String orderId})
    : super(const OrderDetailsState()) {
    on<_Started>((event, emit) {
      add(OrderDetailsEvent.orderRequested());
    });
    on<_OrderRequested>((event, emit) async {
      emit(state.copyWith(isLoadingOrder: true));
      try {
        final order = await _orderRepository.getOrder(orderId);
        emit(state.copyWith(isLoadingOrder: false, order: order));
        add(OrderDetailsEvent.timeSlotsRequested());
      } catch (e) {
        emit(state.copyWith(isLoadingOrder: false, loadingOrderError: AppError.fromObject(e)));
      }
    });
    on<_TimeSlotsRequested>((event, emit) async {
      if (state.order == null) return;
      try {
        final user = await _authRepository.getProfile();
        final timeSlots = await _staffRepository.getVenueStaffTimeSlots(
          staffId: user.id,
          venueId: state.order!.venue.id,
        );
        emit(state.copyWith(timeSlots: timeSlots));
      } catch (_) {
        emit(state.copyWith(timeSlots: []));
      }
    }, transformer: restartable());
    on<_DiscardRequested>((event, emit) async {
      emit(state.copyWith(discardingState: const OrderUpdatingState.loading()));
      try {
        await _orderRepository.discardOrder(id: orderId, reason: event.reason);
        add(OrderDetailsEvent.orderRequested());
        emit(state.copyWith(discardingState: const OrderUpdatingState.initial()));
      } catch (e) {
        emit(state.copyWith(discardingState: OrderUpdatingState.error(AppError.fromObject(e))));
      }
    });
    on<_ApproveRequested>((event, emit) async {
      emit(state.copyWith(confirmingState: const OrderUpdatingState.loading()));
      try {
        await _orderRepository.approveOrder(orderId);
        add(OrderDetailsEvent.orderRequested());
        emit(state.copyWith(confirmingState: const OrderUpdatingState.initial()));
      } catch (e) {
        emit(state.copyWith(confirmingState: OrderUpdatingState.error(AppError.fromObject(e))));
      }
    });
    on<_CompleteRequested>((event, emit) async {
      emit(state.copyWith(completingState: const OrderUpdatingState.loading()));
      try {
        await _orderRepository.completeOrder(orderId);
        emit(state.copyWith(completingState: const OrderUpdatingState.initial()));
        add(OrderDetailsEvent.orderRequested());
      } catch (e) {
        emit(state.copyWith(completingState: OrderUpdatingState.error(AppError.fromObject(e))));
      }
    });
    on<_ChangeTimeSlotRequested>((event, emit) async {
      emit(state.copyWith(changingTimeSlotState: const OrderUpdatingState.loading()));
      try {
        await _orderRepository.changeOrderTime(
          id: orderId,
          time: event.date,
          endTime: event.date.add(state.order?.service.duration ?? Duration(hours: 1)),
        );
        emit(state.copyWith(changingTimeSlotState: const OrderUpdatingState.initial()));
        add(OrderDetailsEvent.orderRequested());
      } catch (e) {
        emit(state.copyWith(changingTimeSlotState: OrderUpdatingState.error(AppError.fromObject(e))));
      }
    });
  }
}
