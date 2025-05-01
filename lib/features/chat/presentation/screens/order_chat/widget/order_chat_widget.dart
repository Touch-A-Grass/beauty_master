import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/presentation/components/chat_view.dart';
import 'package:beauty_master/features/chat/presentation/screens/order_chat/bloc/order_chat_bloc.dart';
import 'package:beauty_master/presentation/components/app_back_button.dart';
import 'package:beauty_master/presentation/models/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderChatWidget extends StatelessWidget {
  const OrderChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderChatBloc, OrderChatState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(title: const Text('Чат'), leading: AppBackButton()),
            body: switch (state.messagesState) {
              ProgressLoadingState<List<ChatEvent>>() => Center(child: CircularProgressIndicator()),
              SuccessLoadingState<List<ChatEvent>> messages => ChatView(
                events: messages.data,
                onSend:
                    state.sendingMessageState is! ProgressSendingState
                        ? (message) {
                          context.read<OrderChatBloc>().add(OrderChatEvent.sendMessageRequested(message));
                        }
                        : null,
              ),
              ErrorLoadingState<List<ChatEvent>> error => Center(child: Text(error.error.message)),
            },
          ),
    );
  }
}
