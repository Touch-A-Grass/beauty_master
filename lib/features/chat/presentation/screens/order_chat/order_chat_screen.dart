import 'package:auto_route/annotations.dart';
import 'package:beauty_master/features/chat/presentation/screens/order_chat/bloc/order_chat_bloc.dart';
import 'package:beauty_master/features/chat/presentation/screens/order_chat/widget/order_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderChatScreen extends StatelessWidget {
  final String orderId;

  const OrderChatScreen({super.key, @PathParam('orderId') required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              OrderChatBloc(context.read(), context.read(), orderId: orderId)..add(const OrderChatEvent.started()),
      child: OrderChatWidget(),
    );
  }
}
