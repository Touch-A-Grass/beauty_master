import 'package:auto_route/annotations.dart';
import 'package:beauty_master/presentation/screens/orders/bloc/orders_bloc.dart';
import 'package:beauty_master/presentation/screens/orders/widget/orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(context.read())..add(OrdersEvent.started()),
      child: const OrdersWidget(),
    );
  }
}
