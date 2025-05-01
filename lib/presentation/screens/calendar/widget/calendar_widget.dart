import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/domain/models/day_schedule.dart';
import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/presentation/components/measure_size.dart';
import 'package:beauty_master/presentation/models/order_status.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/screens/calendar/bloc/calendar_bloc.dart';
import 'package:beauty_master/presentation/screens/calendar/time_slot_edit/time_slot_edit_sheet.dart';
import 'package:beauty_master/presentation/util/date_time_util.dart';
import 'package:beauty_master/presentation/util/string_util.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'schedule_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  dynamic selectedTimeSlot;

  DateTime selectedWeek = DateTime.now();
  final titleFormat = DateFormat('MMMM');

  double bottomSize = 0;

  TimeInterval? currentInterval;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(
              title: Text(titleFormat.format(selectedWeek).capitalize()),
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              shape: Border(),
            ),
            body: Stack(
              children: [
                ScheduleCalendar(
                  currentInterval: currentInterval,
                  isLoading: state.isLoading,
                  currentIntervalChanged: (value) {
                    if (state.isLoading) return;
                    setState(() {
                      currentInterval = value;
                    });
                  },
                  startDate: DateTime.now().dateOnly,
                  onWeekSelected:
                      (week) => setState(() {
                        selectedWeek = week;
                        context.read<CalendarBloc>().add(CalendarEvent.scheduleRequested(week));
                      }),
                  schedule: state.schedule,
                  selectedWorkLoad: selectedTimeSlot,
                  onWorkloadSelected: (workload) {
                    if (state.isLoading) return;
                    setState(() {
                      selectedTimeSlot = workload;
                    });
                  },
                  bottomPadding: bottomSize,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: MeasureSize(
                    onChange: (size) {
                      setState(() {
                        bottomSize = size.height;
                      });
                    },
                    child: switch (selectedTimeSlot) {
                      RecordWorkloadTimeSlot() => RecordInfoSheet(
                        timeSlot: selectedTimeSlot,
                        onClose:
                            () => setState(() {
                              selectedTimeSlot = null;
                              currentInterval = null;
                            }),
                      ),
                      FreeTimeWorkloadTimeSlot s => TimeSlotEditSheet(
                        timeSlot: s,
                        newInterval: currentInterval,
                        onConfirm: (venueId) {
                          if (currentInterval != null) {
                            context.read<CalendarBloc>().add(
                              CalendarEvent.timeSlotEdited(timeSlot: s, interval: currentInterval!),
                            );
                          }
                          setState(() {
                            currentInterval = null;
                            selectedTimeSlot = null;
                          });
                        },
                        onDelete: () {
                          context.read<CalendarBloc>().add(CalendarEvent.timeSlotRemoved(timeSlot: s));
                        },
                        onClose:
                            () => setState(() {
                              currentInterval = null;
                              selectedTimeSlot = null;
                            }),
                      ),
                      _ =>
                        currentInterval != null
                            ? TimeSlotEditSheet(
                              onConfirm: (venueId) {
                                if (currentInterval != null) {
                                  context.read<CalendarBloc>().add(
                                    CalendarEvent.timeSlotAdded(interval: currentInterval!, venueId: venueId),
                                  );
                                }
                                setState(() {
                                  currentInterval = null;
                                  selectedTimeSlot = null;
                                });
                              },
                              newInterval: currentInterval,
                              onClose:
                                  () => setState(() {
                                    currentInterval = null;
                                    selectedTimeSlot = null;
                                  }),
                            )
                            : const SizedBox.shrink(),
                    },
                  ),
                ),
              ],
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
      padding: EdgeInsets.all(16),
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
