import 'dart:async';
import 'dart:typed_data';

import 'package:beauty_master/domain/models/app_error.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/repositories/auth_repository.dart';
import 'package:beauty_master/domain/repositories/order_repository.dart';
import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_live_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message_info.dart';
import 'package:beauty_master/features/chat/domain/models/chat_participant.dart';
import 'package:beauty_master/presentation/models/loading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order_chat_bloc.freezed.dart';
part 'order_chat_event.dart';
part 'order_chat_state.dart';

class OrderChatBloc extends Bloc<OrderChatEvent, OrderChatState> {
  final OrderRepository _orderRepository;
  final AuthRepository _authRepository;
  final String orderId;

  StreamSubscription? _chatSubscription;

  OrderChatBloc(this._orderRepository, this._authRepository, {required this.orderId}) : super(OrderChatState()) {
    on<_Started>((event, emit) async {
      final orderFuture = _orderRepository.getOrder(orderId);
      final chatFuture = _orderRepository.getChatEvents(orderId);
      try {
        final order = await orderFuture;
        emit(state.copyWith(orderState: LoadingState.success(order)));
        try {
          final chatMessagesInfo = await chatFuture;
          final me = await _authRepository.getProfile();
          final participants = <String, ChatParticipant>{
            if (order.staff != null) order.staff!.id: StaffParticipant(order.staff!),
            if (order.user != null) order.user!.id: UserParticipant(order.user!, isOwner: me.id == order.user!.id),
            me.id: StaffProfileParticipant(me, isOwner: true),
          };
          if (order.user != null) {
            participants[order.user!.id] = UserParticipant(order.user!, isOwner: me.id == order.user!.id);
          }
          emit(state.copyWith(participants: participants));
          final List<ChatEvent> events = _mapChatInfoList(chatMessagesInfo);
          emit(state.copyWith(messagesState: LoadingState.success(events)));
          _chatSubscription?.cancel();
          _chatSubscription = _orderRepository.watchOrderChatEvents(orderId).listen((event) {
            switch (event) {
              case EventReceivedChatLiveEvent e:
                add(OrderChatEvent.messageReceived(_mapChatInfo(e.event)));
              case MessageReadChatLiveEvent e:
                add(OrderChatEvent.messageRead(e.messageId));
            }
          });

          add(OrderChatEvent.markAsReadRequested());
        } catch (e, trace) {
          debugPrintStack(stackTrace: trace);
          emit(state.copyWith(messagesState: LoadingState.error(AppError.fromObject(e))));
        }
      } catch (e, trace) {
        debugPrintStack(stackTrace: trace);
        emit(state.copyWith(orderState: LoadingState.error(AppError.fromObject(e))));
      }
    });

    on<_SendMessageRequested>((event, emit) async {
      emit(state.copyWith(sendingMessageState: SendingState.progress()));
      try {
        final messageId = const Uuid().v4();
        if (state.messagesState is SuccessLoadingState) {
          final messages = (state.messagesState as SuccessLoadingState<List<ChatEvent>>).data;
          final sender = await _authRepository.getProfile();
          emit(
            state.copyWith(
              messagesState: LoadingState.success([
                ChatEvent.message(
                  ChatMessage(
                    info: ChatMessageInfo(
                      id: messageId,
                      content: ChatMessageContent.text(event.message),
                      createdAt: DateTime.now(),
                      readAt: null,
                      isRead: false,
                      senderId: sender.id,
                    ),
                    participant: StaffProfileParticipant(sender, isOwner: true),
                    isSent: false,
                  ),
                ),
                ...messages,
              ]),
            ),
          );
        }
        await _orderRepository.sendChatMessage(orderId: orderId, message: event.message, messageId: messageId);
        emit(state.copyWith(sendingMessageState: SendingState.initial()));
      } catch (e) {
        emit(state.copyWith(sendingMessageState: SendingState.error(AppError.fromObject(e))));
      }
    });

    on<_SendImageRequested>((event, emit) async {
      emit(state.copyWith(sendingMessageState: SendingState.progress()));
      try {
        final messageId = const Uuid().v4();
        if (state.messagesState is SuccessLoadingState) {
          final messages = (state.messagesState as SuccessLoadingState<List<ChatEvent>>).data;
          final sender = await _authRepository.getProfile();
          emit(
            state.copyWith(
              messagesState: LoadingState.success([
                ChatEvent.message(
                  ChatMessage(
                    info: ChatMessageInfo(
                      id: messageId,
                      content: ChatMessageContent.image(event.image),
                      createdAt: DateTime.now(),
                      readAt: null,
                      isRead: false,
                      senderId: sender.id,
                    ),
                    participant: StaffProfileParticipant(sender, isOwner: true),
                    isSent: false,
                  ),
                ),
                ...messages,
              ]),
            ),
          );
        }
        await _orderRepository.sendChatImage(orderId: orderId, image: event.image, messageId: messageId);
        emit(state.copyWith(sendingMessageState: SendingState.initial()));
      } catch (e) {
        emit(state.copyWith(sendingMessageState: SendingState.error(AppError.fromObject(e))));
      }
    });


    on<_MarkAsReadRequested>((event, emit) {
      if (state.messagesState is SuccessLoadingState) {
        final messages = (state.messagesState as SuccessLoadingState<List<ChatEvent>>).data;
        final toMark =
        messages
            .where((e) => e is MessageChatEvent && !e.message.info.isRead && !e.message.participant.isOwner)
            .map((e) => (e as MessageChatEvent).message.info.id)
            .toList();

        if (toMark.isNotEmpty) {
          _orderRepository.markAsRead(orderId: orderId, messageIds: toMark);
        }
      }
    });

    on<_MessageRead>((event, emit) {
      if (state.messagesState is SuccessLoadingState) {
        final messages =
            (state.messagesState as SuccessLoadingState<List<ChatEvent>>).data.map((e) {
              if (e is MessageChatEvent && e.message.info.id == event.messageId) {
                return e.copyWith(message: e.message.copyWith(info: e.message.info.copyWith(isRead: true)));
              }
              return e;
            }).toList();

        emit(state.copyWith(messagesState: LoadingState.success(messages)));
      }
    });

    on<_MessageReceived>((event, emit) {
      switch (state.messagesState) {
        case SuccessLoadingState<List<ChatEvent>> messages:
          final ChatEvent message = event.message;
          final List<ChatEvent> oldMessages =
              messages.data
                  .where(
                    (e) =>
                        message is! MessageChatEvent ||
                        e is! MessageChatEvent ||
                        e.message.info.id != message.message.info.id,
                  )
                  .toList();
          final List<ChatEvent> newMessages = <ChatEvent>[event.message, ...oldMessages];
          emit(state.copyWith(messagesState: LoadingState.success(newMessages)));
          add(OrderChatEvent.markAsReadRequested());
        case ProgressLoadingState<List<ChatEvent>>():
        case ErrorLoadingState<List<ChatEvent>>():
      }
    });
  }

  @override
  Future<void> close() async {
    _chatSubscription?.cancel();
    super.close();
  }

  List<ChatEvent> _mapChatInfoList(List<ChatEventInfo> events) => events.map(_mapChatInfo).toList();

  ChatEvent _mapChatInfo(ChatEventInfo e) => switch (e) {
    MessageChatEventInfo e => ChatEvent.message(
      ChatMessage(
        info: e.message,
        participant: state.participants[e.message.senderId] ?? UnknownParticipant(e.message.senderId),
      ),
    ),
    StatusLogChatEventInfo e => ChatEvent.statusLog(e.log),
  };
}
