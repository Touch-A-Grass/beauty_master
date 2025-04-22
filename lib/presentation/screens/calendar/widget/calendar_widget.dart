import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/presentation/models/order_status.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/screens/calendar/bloc/calendar_bloc.dart';
import 'package:beauty_master/presentation/util/string_util.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final calendarController = EventController();
  dynamic selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listenWhen: (prev, curr) => prev.schedule != curr.schedule,
      listener: (context, state) {
        calendarController.removeWhere((e) => true);
        for (final day in state.schedule.keys) {
          final workloads = state.schedule[day]!.workload;
          calendarController.addAll(
            workloads
                .map(
                  (e) => CalendarEventData(
                    date: day,
                    title: '',
                    event: e,
                    startTime: e.timeInterval.start,
                    endTime: e.timeInterval.end,
                    color: switch (e) {
                      FreeTimeWorkloadTimeSlot() => Colors.grey,
                      RecordWorkloadTimeSlot slot =>  slot.recordInfo.status.color(),
                    },
                  ),
                )
                .toList(),
          );
        }
      },
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder:
            (context, state) => Scaffold(
              appBar: AppBar(title: Text('График работы')),
              body: Stack(
                children: [
                  WeekView(
                    headerStringBuilder: (date, {secondaryDate}) {
                      final format = DateFormat('dd.MM.yyyy');
                      if (secondaryDate == null) return format.format(date);
                      return '${format.format(date)} - ${format.format(secondaryDate)}';
                    },
                    pageViewPhysics: NeverScrollableScrollPhysics(),
                    weekDayStringBuilder: (date) => getWeekdayName(date + 1, 'EE').capitalize(),
                    onEventTap: (event, date) {
                      final e = event.firstOrNull?.event;
                      if (e == null) return;
                      setState(() {
                        selectedTimeSlot = e;
                      });
                    },
                    headerStyle: HeaderStyle(
                      headerTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
                      leftIconConfig: IconDataConfig(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      rightIconConfig: IconDataConfig(color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    controller: calendarController,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onPageChange: (DateTime date, int index) {
                      context.read<CalendarBloc>().add(CalendarEvent.scheduleRequested(date));
                    },
                    eventTileBuilder:
                        (
                          DateTime date,
                          List<CalendarEventData> events,
                          Rect boundary,
                          DateTime startDuration,
                          DateTime endDuration,
                        ) => Container(
                          decoration: BoxDecoration(
                            color: events.firstOrNull?.color,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                selectedTimeSlot?.id == (events.firstOrNull?.event as WorkloadTimeSlot).id.toString()
                                    ? Border.all(color: Theme.of(context).colorScheme.outline, width: 2)
                                    : null,
                          ),
                        ),
                  ),
                  if (selectedTimeSlot != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: switch (selectedTimeSlot) {
                        RecordWorkloadTimeSlot() => RecordInfoSheet(
                          timeSlot: selectedTimeSlot,
                          onClose: () => setState(() => selectedTimeSlot = null),
                        ),
                        FreeTimeWorkloadTimeSlot s => TimeSlotEditSheet(
                          timeSlot: s,
                          onClose: () => setState(() => selectedTimeSlot = null),
                        ),
                        _ => const SizedBox(),
                      },
                    ),
                ],
              ),
            ),
      ),
    );
  }
}

class RecordInfoSheet extends StatefulWidget {
  final RecordWorkloadTimeSlot timeSlot;
  final VoidCallback onClose;

  const RecordInfoSheet({super.key, required this.timeSlot, required this.onClose});

  @override
  State<RecordInfoSheet> createState() => _RecordInfoSheetState();
}

class _RecordInfoSheetState extends State<RecordInfoSheet> {
  final dateFormatter = DateFormat('dd MMMM HH:mm');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) + EdgeInsets.all(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.pushRoute(OrderDetailsRoute(orderId: widget.timeSlot.recordInfo.id)),
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 8,
                    decoration: BoxDecoration(
                      color: widget.timeSlot.recordInfo.status.color(),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Column(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.timeSlot.recordInfo.serviceName,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.person_rounded, size: 16),
                              Expanded(
                                child: Text(
                                  widget.timeSlot.recordInfo.clientName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.timeSlot.recordInfo.status.statusName(context),
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              Text(
                                dateFormatter.format(widget.timeSlot.timeInterval.start.toLocal()),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close_rounded)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeSlotEditSheet extends StatefulWidget {
  final FreeTimeWorkloadTimeSlot timeSlot;
  final VoidCallback onClose;

  const TimeSlotEditSheet({super.key, required this.timeSlot, required this.onClose});

  @override
  State<TimeSlotEditSheet> createState() => _TimeSlotEditSheetState();
}

class _TimeSlotEditSheetState extends State<TimeSlotEditSheet> {
  final startHoursController = TextEditingController();
  final startMinutesController = TextEditingController();
  final endHoursController = TextEditingController();
  final endMinutesController = TextEditingController();

  void _initTime() {
    startHoursController.text = widget.timeSlot.timeInterval.start.hour.toString().padLeft(2, '0');
    startMinutesController.text = widget.timeSlot.timeInterval.start.minute.toString().padLeft(2, '0');
    endHoursController.text = widget.timeSlot.timeInterval.end.hour.toString().padLeft(2, '0');
    endMinutesController.text = widget.timeSlot.timeInterval.end.minute.toString().padLeft(2, '0');
  }

  @override
  void didUpdateWidget(covariant TimeSlotEditSheet oldWidget) {
    if (oldWidget.timeSlot != widget.timeSlot) _initTime();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) + EdgeInsets.all(16),
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
                Expanded(child: Text('Время работы', style: Theme.of(context).textTheme.titleLarge)),
                IconButton(onPressed: widget.onClose, icon: const Icon(Icons.delete_rounded)),
              ],
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
                Expanded(child: FilledButton(onPressed: () {}, child: Text('Сохранить'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    maxLength: 2,
    textAlign: TextAlign.center,
    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.all(4),
    ),
  );
}
