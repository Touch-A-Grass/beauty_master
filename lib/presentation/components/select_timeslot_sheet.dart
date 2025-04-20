import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/domain/models/service.dart';
import 'package:beauty_master/domain/models/staff_time_slot.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:beauty_master/presentation/components/app_draggable_modal_sheet.dart';
import 'package:beauty_master/presentation/components/sliver_pinned_header_no_space.dart';
import 'package:beauty_master/presentation/util/string_util.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectTimeslotSheet extends StatefulWidget {
  final List<StaffTimeSlot> timeSlots;
  final Service service;

  const SelectTimeslotSheet({super.key, required this.timeSlots, required this.service});

  @override
  State<SelectTimeslotSheet> createState() => _SelectTimeslotSheetState();
}

class _SelectTimeslotSheetState extends State<SelectTimeslotSheet> {
  StaffTimeSlot? selectedTimeSlot;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final duration = widget.service.duration ?? Duration(hours: 1);
    final modifiedTimeSlots =
        widget.timeSlots
            .where(
              (timeSlot) => timeSlot.intervals.any((interval) => interval.end.difference(interval.start) >= duration),
            )
            .sortedBy((e) => e.date)
            .toList();

    final Map<(int, int, int), StaffTimeSlot> timeSlotsMap = {};
    for (final timeSlot in modifiedTimeSlots) {
      timeSlotsMap[(timeSlot.date.year, timeSlot.date.month, timeSlot.date.day)] = timeSlot;
    }

    var dateTime = modifiedTimeSlots.firstOrNull?.date ?? DateTime.now();

    if (dateTime.month != DateTime.now().month) dateTime = dateTime.copyWith(day: 1);

    for (int i = 0; i < 365; i++) {
      final t = dateTime.add(Duration(days: i));
      timeSlotsMap[(t.year, t.month, t.day)] =
          timeSlotsMap[(t.year, t.month, t.day)] ?? StaffTimeSlot(date: t, id: '$i', intervals: []);
    }

    final groupedTimeSlots = timeSlotsMap.values
        .sortedBy((e) => e.date)
        .groupListsBy((e) => (e.date.year, e.date.month));

    return AppDraggableModalSheet(
      builder:
          (context, scrollController) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverMainAxisGroup(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                S.of(context).cartDateTitle,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 16),
                            sliver: SliverToBoxAdapter(
                              child: SizedBox(
                                width: double.infinity,
                                height: 116,
                                child: CustomScrollView(
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  slivers: [
                                    for (final groupedTimeSlot in groupedTimeSlots.entries)
                                      SliverMainAxisGroup(
                                        slivers: [
                                          SliverPinnedHeaderNoSpace(
                                            child: IgnorePointer(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  height: 48,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 16),
                                                    child: Center(
                                                      child: Text(
                                                        DateFormat('MMMM')
                                                            .format(
                                                              DateTime(groupedTimeSlot.key.$1, groupedTimeSlot.key.$2),
                                                            )
                                                            .capitalize(),
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                        textAlign: TextAlign.end,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SliverList.builder(
                                            itemCount: groupedTimeSlot.value.length,
                                            itemBuilder:
                                                (context, index) => Padding(
                                                  padding: EdgeInsets.only(top: 48, left: 16),
                                                  child: _TimeSlotDate(
                                                    groupedTimeSlot.value[index],
                                                    selectedTimeSlot?.id == groupedTimeSlot.value[index].id,
                                                    () => setState(() {
                                                      selectedTimeSlot = groupedTimeSlot.value[index];
                                                      selectedDate =
                                                          groupedTimeSlot.value[index].intervals.firstOrNull?.start;
                                                    }),
                                                  ),
                                                ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (selectedTimeSlot != null)
                            SliverPadding(
                              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                              sliver: SliverMainAxisGroup(
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Text(
                                      S.of(context).cartTimeDialogIntervalTitle,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.only(top: 16),
                                    sliver: _TimeSlotSliver(
                                      selectedTimeSlot!,
                                      duration,
                                      (date) => setState(() => selectedDate = date),
                                      selectedDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                                  top: 32,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: selectedDate != null ? () => context.maybePop(selectedDate) : null,
                                    child: Text(S.of(context).cartConfirmButton),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(top: 8, right: 8, child: CloseButton()),
                ],
              ),
            ),
          ),
    );
  }
}

class _TimeSlotDate extends StatefulWidget {
  final StaffTimeSlot timeSlot;
  final bool isSelected;
  final VoidCallback? onTap;

  const _TimeSlotDate(this.timeSlot, this.isSelected, this.onTap);

  @override
  State<_TimeSlotDate> createState() => _TimeSlotDateState();
}

class _TimeSlotDateState extends State<_TimeSlotDate> {
  final dayOfWeekFormat = DateFormat.E();

  final dateFormat = DateFormat('d');

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 250),
      style:
          widget.timeSlot.intervals.isEmpty
              ? Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.shadow)
              : widget.isSelected
              ? Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary)
              : Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
      child: AnimatedContainer(
        height: 64,
        width: 48,
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              widget.timeSlot.intervals.isEmpty
                  ? Theme.of(context).colorScheme.surfaceContainerLow
                  : widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.timeSlot.intervals.isNotEmpty ? widget.onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dayOfWeekFormat.format(widget.timeSlot.date)),
                Text(dateFormat.format(widget.timeSlot.date)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeIntervalField extends StatefulWidget {
  final DateTime start;
  final Duration serviceDuration;
  final VoidCallback? onTap;
  final bool isSelected;

  const _TimeIntervalField({required this.start, required this.serviceDuration, this.onTap, this.isSelected = false});

  @override
  State<_TimeIntervalField> createState() => _TimeIntervalFieldState();
}

class _TimeIntervalFieldState extends State<_TimeIntervalField> {
  final format = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Text(
          format.format(widget.start),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color:
                widget.isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _TimeSlotSliver extends StatefulWidget {
  final StaffTimeSlot staffTimeSlot;
  final Duration serviceDuration;
  final ValueChanged<DateTime> onTap;
  final DateTime? selectedDate;

  const _TimeSlotSliver(this.staffTimeSlot, this.serviceDuration, this.onTap, this.selectedDate);

  @override
  State<_TimeSlotSliver> createState() => _TimeSlotSliverState();
}

class _TimeSlotSliverState extends State<_TimeSlotSliver> {
  final dateFormat = DateFormat('d MMMM, EEEE');
  final timeFormat = DateFormat('HH:mm');

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final slots = <DateTime>[];

    for (final interval in widget.staffTimeSlot.intervals) {
      var currentTime = interval.start;
      while (currentTime.add(widget.serviceDuration).isBefore(interval.end) ||
          currentTime.add(widget.serviceDuration).isAtSameMomentAs(interval.end)) {
        slots.add(currentTime);
        currentTime = currentTime.add(widget.serviceDuration);
      }
    }

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: slots.length,
      itemBuilder:
          (context, index) => _TimeIntervalField(
            start: slots[index],
            serviceDuration: widget.serviceDuration,
            onTap: () => widget.onTap(slots[index]),
            isSelected: slots[index] == widget.selectedDate,
          ),
    );
  }
}
