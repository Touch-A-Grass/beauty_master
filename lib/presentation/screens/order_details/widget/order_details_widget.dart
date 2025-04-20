import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/error_snackbar.dart';
import 'package:beauty_master/presentation/models/order_status.dart';
import 'package:beauty_master/presentation/screens/order_details/bloc/order_details_bloc.dart';
import 'package:beauty_master/presentation/util/bloc_single_change_listener.dart';
import 'package:beauty_master/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

part 'order_info_item.dart';
part 'order_time_info.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({super.key});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocSingleChangeListener<OrderDetailsBloc, OrderDetailsState>(
      map: (state) => state.loadingOrderError,
      listener: (context, state) => context.showErrorSnackBar(state.loadingOrderError!),
      child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder:
            (context, state) => Scaffold(
              appBar: AppBar(title: Text(S.of(context).orderDetailsTitle)),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    state.order == null
                        ? const Center(child: CircularProgressIndicator())
                        : Builder(
                          builder: (context) {
                            final order = state.order!;
                            return Stack(
                              children: [
                                CustomScrollView(
                                  slivers: [
                                    SliverPadding(
                                      padding: EdgeInsets.all(16),
                                      sliver: SliverMainAxisGroup(
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surfaceContainer,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: DividerTheme(
                                                data: Theme.of(
                                                  context,
                                                ).dividerTheme.copyWith(endIndent: 0, indent: 0, space: 32),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    _OrderInfoItem(
                                                      Text(S.of(context).cartService),
                                                      Text(order.service.name),
                                                    ),
                                                    Divider(),
                                                    _OrderInfoItem(Text(S.of(context).venue), Text(order.venue.name)),
                                                    Divider(),
                                                    _OrderTimeInfo(order: order),
                                                    if (order.service.duration != null) ...[
                                                      Divider(),
                                                      _OrderInfoItem(
                                                        Text(S.of(context).serviceDuration),
                                                        Text('~ ${order.service.duration!.inMinutes} мин.'),
                                                      ),
                                                    ],
                                                    if (order.service.price != null) ...[
                                                      Divider(),
                                                      _OrderInfoItem(
                                                        Text(
                                                          S.of(context).orderPrice,
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          order.service.price!.toPriceFormat(),
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                    Divider(),
                                                    _OrderInfoItem(
                                                      Text(
                                                        S.of(context).orderStatus,
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        order.status.statusName(context),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: order.status.color(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SafeArea(
                                          top: false,
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              spacing: 16,
                                              children: [
                                                if (state.canDiscardOrder) Expanded(child: _DiscardButton(state)),
                                                if (state.canApproveOrder)
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 48,
                                                      child: FilledButton(onPressed: () {}, child: Text('Подтвердить')),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.isLoadingOrder)
                                  Positioned(
                                    bottom: MediaQuery.of(context).padding.bottom,
                                    left: 0,
                                    right: 0,
                                    child: LinearProgressIndicator(),
                                  ),
                              ],
                            );
                          },
                        ),
              ),
            ),
      ),
    );
  }
}

class _DiscardButton extends StatelessWidget {
  final OrderDetailsState state;

  const _DiscardButton(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed:
            state.discardingState is InitialOrderDiscardingState
                ? () async {
                  final result = await showDialog<bool>(context: context, builder: (context) => _DiscardDialog());
                  if (context.mounted && result == true) {
                    context.read<OrderDetailsBloc>().add(const OrderDetailsEvent.discardRequested());
                  }
                }
                : null,
        child: switch (state.discardingState) {
          InitialOrderDiscardingState() => Text(S.of(context).orderCancelButton),
          LoadingOrderDiscardingState() => const Center(
            child: SizedBox.square(dimension: 24, child: CircularProgressIndicator()),
          ),
          ErrorOrderDiscardingState s => Text(s.error.message),
        },
      ),
    );
  }
}

class _DiscardDialog extends StatefulWidget {
  const _DiscardDialog();

  @override
  State<_DiscardDialog> createState() => _DiscardDialogState();
}

class _DiscardDialogState extends State<_DiscardDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(S.of(context).orderCancelAlertTitle, style: Theme.of(context).textTheme.headlineSmall),
                Text(S.of(context).orderCancelAlertMessage),
                TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder(), label: Text('Причина отмены')),
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                  maxLines: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          S.of(context).orderCancelAlertConfirm,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(S.of(context).orderCancelAlertCancel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
