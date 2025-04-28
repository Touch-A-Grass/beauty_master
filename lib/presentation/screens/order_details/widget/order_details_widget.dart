import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/order_review.dart';
import 'package:beauty_master/domain/models/user.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/error_snackbar.dart';
import 'package:beauty_master/presentation/components/rating_view.dart';
import 'package:beauty_master/presentation/components/select_timeslot_sheet.dart';
import 'package:beauty_master/presentation/models/order_status.dart';
import 'package:beauty_master/presentation/screens/order_details/bloc/order_details_bloc.dart';
import 'package:beauty_master/presentation/util/bloc_single_change_listener.dart';
import 'package:beauty_master/presentation/util/image_util.dart';
import 'package:beauty_master/presentation/util/phone_formatter.dart';
import 'package:beauty_master/presentation/util/price_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

part 'client_profile_info.dart';
part 'order_info_item.dart';
part 'order_review_view.dart';
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
                                                    if (order.status == OrderStatus.discarded &&
                                                        order.comment.isNotEmpty) ...[
                                                      _OrderInfoItem(
                                                        Text(S.of(context).orderCancelReasonTitle),
                                                        Expanded(child: Text(order.comment, textAlign: TextAlign.end)),
                                                      ),
                                                      Divider(),
                                                    ],
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
                                                    if (state.order?.user != null) ...[
                                                      Divider(),
                                                      _ClientProfileInfo(state.order!.user!),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (order.review != null)
                                            SliverPadding(
                                              padding: const EdgeInsets.only(top: 16),
                                              sliver: SliverToBoxAdapter(child: _OrderRatingView(order.review!)),
                                            ),
                                          if (state.canChangeTime)
                                            SliverPadding(
                                              padding: const EdgeInsets.only(top: 16),
                                              sliver: SliverMainAxisGroup(
                                                slivers: [SliverToBoxAdapter(child: _ChangeTimeButton(state))],
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
                                                if (state.canApproveOrder) Expanded(child: _ApproveButton(state)),
                                                if (state.canCompleteOrder) Expanded(child: _CompleteButton(state)),
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

class _ChangeTimeButton extends StatelessWidget {
  final OrderDetailsState state;

  const _ChangeTimeButton(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed:
            state.timeSlots != null && state.changingTimeSlotState is InitialOrderUpdatingState
                ? () async {
                  final date = await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder:
                        (childContext) =>
                            SelectTimeslotSheet(timeSlots: state.timeSlots ?? [], service: state.order!.service),
                  );

                  if (context.mounted && date != null) {
                    context.read<OrderDetailsBloc>().add(OrderDetailsEvent.changeTimeSlotRequested(date));
                  }
                }
                : null,
        child:
            state.changingTimeSlotState is InitialOrderUpdatingState && state.timeSlots != null
                ? Text('Перенести запись')
                : Center(child: CircularProgressIndicator()),
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
            state.discardingState is InitialOrderUpdatingState
                ? () async {
                  await showDialog<bool>(
                    context: context,
                    builder:
                        (childContext) => _DiscardDialog((reason) {
                          context.read<OrderDetailsBloc>().add(OrderDetailsEvent.discardRequested(reason));
                        }),
                  );
                }
                : null,
        child: switch (state.discardingState) {
          InitialOrderUpdatingState() => Text(S.of(context).orderCancelButton),
          LoadingOrderUpdatingState() => Center(
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          ErrorOrderUpdatingState s => Text(s.error.message),
        },
      ),
    );
  }
}

class _ApproveButton extends StatelessWidget {
  final OrderDetailsState state;

  const _ApproveButton(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed:
            state.confirmingState is InitialOrderUpdatingState
                ? () async {
                  final dialog = await showAdaptiveDialog(
                    context: context,
                    builder:
                        (childContext) => AlertDialog(
                          title: Text(S.of(context).orderApproveDialogTitle),
                          content: Text(S.of(context).orderApproveDialogMessage),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(childContext, false),
                              child: Text(S.of(context).dialogNo),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(childContext, true),
                              child: Text(S.of(context).dialogYes),
                            ),
                          ],
                        ),
                  );
                  if (dialog == true && context.mounted) {
                    context.read<OrderDetailsBloc>().add(OrderDetailsEvent.approveRequested());
                  }
                }
                : null,
        child: switch (state.confirmingState) {
          InitialOrderUpdatingState() => Text(S.of(context).orderApproveButton),
          LoadingOrderUpdatingState() => Center(
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          ErrorOrderUpdatingState s => Text(s.error.message),
        },
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final OrderDetailsState state;

  const _CompleteButton(this.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed:
            state.confirmingState is InitialOrderUpdatingState
                ? () async {
                  final dialog = await showAdaptiveDialog(
                    context: context,
                    builder:
                        (childContext) => AlertDialog(
                          title: Text(S.of(context).orderCompleteDialogTitle),
                          content: Text(S.of(context).orderCompleteDialogMessage),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(childContext, false),
                              child: Text(S.of(context).dialogNo),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(childContext, true),
                              child: Text(S.of(context).dialogYes),
                            ),
                          ],
                        ),
                  );
                  if (dialog == true && context.mounted) {
                    context.read<OrderDetailsBloc>().add(OrderDetailsEvent.completeRequested());
                  }
                }
                : null,
        child: switch (state.completingState) {
          InitialOrderUpdatingState() => Text(S.of(context).orderCompleteButton),
          LoadingOrderUpdatingState() => const Center(
            child: SizedBox.square(dimension: 24, child: CircularProgressIndicator()),
          ),
          ErrorOrderUpdatingState s => Text(s.error.message),
        },
      ),
    );
  }
}

class _DiscardDialog extends StatefulWidget {
  final ValueChanged<String> onDiscard;

  const _DiscardDialog(this.onDiscard);

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
                  minLines: 1,
                  maxLines: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                        onPressed:
                            controller.text.trim().isEmpty
                                ? null
                                : () {
                                  widget.onDiscard(controller.text.trim());
                                  Navigator.pop(context, true);
                                },
                        child: Text(S.of(context).orderCancelAlertConfirm),
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
