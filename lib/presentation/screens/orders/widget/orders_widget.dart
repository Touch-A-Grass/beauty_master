import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/domain/models/calendar_day_status.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/app_overlay.dart';
import 'package:beauty_master/presentation/components/error_snackbar.dart';
import 'package:beauty_master/presentation/components/paging_listener.dart';
import 'package:beauty_master/presentation/components/shimmer_box.dart';
import 'package:beauty_master/presentation/models/order_status.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/screens/orders/bloc/orders_bloc.dart';
import 'package:beauty_master/presentation/util/price_utils.dart';
import 'package:beauty_master/presentation/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'order_calendar.dart';
part 'order_list_item.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  final selectedDateFormat = DateFormat('d MMMM');

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (prev, curr) => !identical(prev.loadingError, curr.loadingError) && curr.loadingError != null,
      listener: (context, state) {
        if (state.loadingError == null) return;
        context.showErrorSnackBar(state.loadingError!);
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder:
            (context, state) => AppOverlay(
              child: Scaffold(
                appBar: AppBar(title: Text(S.of(context).records)),
                body: PagingListener(
                  onPageEnd: () {
                    if (state.orders.hasNext && !state.isLoadingOrders) {
                      context.read<OrdersBloc>().add(OrdersEvent.ordersRequested());
                    }
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                        sliver: SliverToBoxAdapter(
                          child: _OrderCalendar(
                            monthStatus: state.monthStatus,
                            selectedDay: state.selectedDate,
                            selectedMonth: state.selectedMonth,
                            onDateSelected: (date) {
                              context.read<OrdersBloc>().add(OrdersEvent.selectedDayChanged(date));
                            },
                            onMonthSelected: (date) {
                              context.read<OrdersBloc>().add(OrdersEvent.selectedMonthChanged(date));
                            },
                          ),
                        ),
                      ),
                      if (state.isLoadingOrders && state.orders.data.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (!state.isLoadingOrders && state.orders.data.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text(S.of(context).noRecordsForSelectedDay)),
                        )
                      else
                        SliverPadding(
                          padding:
                              const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                          sliver: SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Text(
                                  selectedDateFormat.format(state.selectedDate),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.only(top: 16),
                                sliver: SliverList.separated(
                                  itemBuilder:
                                      (context, index) => _OrderListItem(
                                        order: state.orders.data[index],
                                        onTap: () {
                                          context.pushRoute(OrderDetailsRoute(orderId: state.orders.data[index].id));
                                        },
                                      ),
                                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                                  itemCount: state.orders.data.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
