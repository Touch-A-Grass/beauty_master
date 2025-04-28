import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:beauty_master/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_master/presentation/components/venue_info_view.dart';
import 'package:beauty_master/presentation/screens/calendar/time_slot_edit/bloc/time_slot_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotEditWidget extends StatefulWidget {
  final VoidCallback onClose;
  final TimeInterval? newInterval;
  final ValueChanged<String> onConfirm;
  final VoidCallback? onDelete;

  const TimeSlotEditWidget({
    super.key,
    required this.onClose,
    this.newInterval,
    required this.onConfirm,
    this.onDelete,
  });

  @override
  State<TimeSlotEditWidget> createState() => _TimeSlotEditWidgetState();
}

class _TimeSlotEditWidgetState extends State<TimeSlotEditWidget> {
  final startHoursController = TextEditingController();
  final startMinutesController = TextEditingController();
  final endHoursController = TextEditingController();
  final endMinutesController = TextEditingController();

  TimeInterval get timeInterval => widget.newInterval ?? context.read<TimeSlotEditBloc>().state.timeSlot!.timeInterval;

  void _initTime() {
    startHoursController.text = timeInterval.start.hour.toString().padLeft(2, '0');
    startMinutesController.text = timeInterval.start.minute.toString().padLeft(2, '0');
    endHoursController.text = timeInterval.end.hour.toString().padLeft(2, '0');
    endMinutesController.text = timeInterval.end.minute.toString().padLeft(2, '0');
  }

  @override
  void didUpdateWidget(covariant TimeSlotEditWidget oldWidget) {
    if (widget.newInterval != oldWidget.newInterval) _initTime();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSlotEditBloc, TimeSlotEditState>(
      builder:
          (context, state) => Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.timeSlot != null ? 'Изменить время' : 'Добавить время',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (widget.onDelete != null)
                        IconButton(onPressed: widget.onDelete, icon: const Icon(Icons.delete_rounded)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.selectedVenue != null)
                    VenueInfoView(
                      venue: state.selectedVenue!,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      onTap:
                          state.timeSlot == null
                              ? () {
                                changeVenue(context, state.venues);
                              }
                              : null,
                    )
                  else
                    OutlinedButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () {
                                changeVenue(context, state.venues);
                              },
                      child:
                          state.isLoading
                              ? Center(child: SizedBox.square(dimension: 20, child: CircularProgressIndicator()))
                              : Text('Укажите салон'),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: buildTextField(startHoursController)),
                      const SizedBox(width: 4),
                      Text(':'),
                      const SizedBox(width: 4),
                      Expanded(child: buildTextField(startMinutesController)),
                      const SizedBox(width: 8),
                      Text('—'),
                      const SizedBox(width: 8),
                      Expanded(child: buildTextField(endHoursController)),
                      const SizedBox(width: 4),
                      Text(':'),
                      const SizedBox(width: 4),
                      Expanded(child: buildTextField(endMinutesController)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: widget.onClose, child: Text('Отменить'))),
                      SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed:
                              state.selectedVenue == null ? null : () => widget.onConfirm.call(state.selectedVenue!.id),
                          child: Text('Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> changeVenue(BuildContext context, List<Venue> venues) async {
    final selectedVenue = await showModalBottomSheet<Venue>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _SelectVenueSheet(venues: venues),
    );
    if (context.mounted && selectedVenue != null) {
      context.read<TimeSlotEditBloc>().add(TimeSlotEditEvent.venueSelected(selectedVenue));
    }
  }

  Widget buildTextField(TextEditingController controller) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    maxLength: 2,
    textAlign: TextAlign.center,
    readOnly: true,
    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.all(4),
    ),
  );
}

class _SelectVenueSheet extends StatelessWidget {
  final List<Venue> venues;

  const _SelectVenueSheet({required this.venues});

  @override
  Widget build(BuildContext context) {
    return AppDraggableModalSheet(
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(child: Text('Выберите салон', style: Theme.of(context).textTheme.titleLarge)),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                        sliver: SliverList.separated(
                          itemCount: venues.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder:
                              (context, index) => VenueInfoView(
                                venue: venues[index],
                                onTap: () => Navigator.pop(context, venues[index]),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
