import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/presentation/screens/order_details/bloc/order_details_bloc.dart';
import 'package:beauty_master/presentation/screens/order_details/widget/order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, @PathParam('orderId') required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc(context.read(), orderId: orderId)..add(OrderDetailsEvent.started()),
      child: const OrderDetailsWidget(),
    );
  }
}
