part of 'calendar_widget.dart';

class ScheduleCalendar extends StatefulWidget {
  final DateTime startDate;
  final ValueChanged<DateTime> onWeekSelected;
  final Map<DateTime, List<DaySchedule>> schedule;
  final ValueChanged<WorkloadTimeSlot?> onWorkloadSelected;
  final WorkloadTimeSlot? selectedWorkLoad;
  final double bottomPadding;
  final TimeInterval? currentInterval;
  final ValueChanged<TimeInterval?> currentIntervalChanged;
  final bool isLoading;

  const ScheduleCalendar({
    super.key,
    required this.startDate,
    required this.onWeekSelected,
    required this.schedule,
    required this.onWorkloadSelected,
    this.selectedWorkLoad,
    required this.bottomPadding,
    this.currentInterval,
    required this.currentIntervalChanged,
    required this.isLoading,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  static const maxWeeksBack = 10;

  double height = 64;
  final pageController = PageController(initialPage: maxWeeksBack);

  set currentInterval(TimeInterval? value) {
    widget.currentIntervalChanged(value);
  }

  TimeInterval? get currentInterval => widget.currentInterval;

  TimeInterval? currentDragInterval;

  TimeInterval? get drawingInterval => currentDragInterval ?? widget.currentInterval;

  late final DateTime initialDate;

  DateTime getDay(int page, int dayIndex) => initialDate.add(Duration(days: (page - maxWeeksBack) * 7 + dayIndex));

  DateTime getHour(int page, int dayIndex, int hourIndex) => getDay(page, dayIndex).add(Duration(hours: hourIndex));

  double getIntervalHeight(TimeInterval interval) {
    return height * (interval.end.hour + interval.end.minute / 60) -
        height * (interval.start.hour + interval.start.minute / 60);
  }

  Offset getIntervalPosition(TimeInterval interval, double dayWidth) {
    return Offset(
      ((interval.start.weekday - 1) % 7) * dayWidth,
      height * (interval.start.hour + interval.start.minute / 60),
    );
  }

  @override
  void initState() {
    var day = widget.startDate;
    while (day.weekday != 1) {
      day = day.subtract(const Duration(days: 1));
    }
    initialDate = day;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => widget.onWeekSelected(initialDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (page) {
              widget.onWeekSelected(initialDate.add(Duration(days: (page - maxWeeksBack) * 7)));
            },
            itemBuilder:
                (context, page) => Stack(
                  children: [
                    Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer),
                          child: Row(
                            children: [
                              SizedBox(width: 48),
                              ...List.generate(
                                7,
                                (index) => Expanded(
                                  child: DayWidget(
                                    date: initialDate.add(Duration(days: index + (page - maxWeeksBack) * 7)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom + 16 + widget.bottomPadding,
                            ),
                            child: Row(
                              children: [
                                Column(children: List.generate(24, (index) => HourWidget(hour: index, height: height))),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final dayWidth = (constraints.maxWidth) / 7;
                                      return Stack(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              7,
                                              (dayIndex) => Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: List.generate(
                                                    24,
                                                    (hourIndex) => Container(
                                                      height: height,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            width: 1,
                                                            color: Theme.of(context).colorScheme.shadow,
                                                          ),
                                                          bottom:
                                                              hourIndex < 23
                                                                  ? BorderSide(
                                                                    width: 1,
                                                                    color: Theme.of(context).colorScheme.shadow,
                                                                  )
                                                                  : BorderSide.none,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: GestureDetector(
                                                              behavior: HitTestBehavior.translucent,
                                                              onTap:
                                                                  hourIndex < 23
                                                                      ? () {
                                                                        widget.onWorkloadSelected(null);
                                                                        setState(() {
                                                                          currentInterval = TimeInterval(
                                                                            start: getHour(
                                                                              page,
                                                                              dayIndex,
                                                                              hourIndex,
                                                                            ),
                                                                            end: getHour(
                                                                              page,
                                                                              dayIndex,
                                                                              hourIndex,
                                                                            ).add(const Duration(hours: 1)),
                                                                          );
                                                                        });
                                                                      }
                                                                      : null,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: GestureDetector(
                                                              behavior: HitTestBehavior.translucent,
                                                              onTap:
                                                                  hourIndex < 23
                                                                      ? () {
                                                                        widget.onWorkloadSelected(null);
                                                                        setState(() {
                                                                          currentInterval = TimeInterval(
                                                                            start: getHour(
                                                                              page,
                                                                              dayIndex,
                                                                              hourIndex,
                                                                            ).add(const Duration(minutes: 30)),
                                                                            end: getHour(
                                                                              page,
                                                                              dayIndex,
                                                                              hourIndex,
                                                                            ).add(
                                                                              const Duration(hours: 1, minutes: 30),
                                                                            ),
                                                                          );
                                                                        });
                                                                      }
                                                                      : null,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          for (var day = 0; day < 7; day++)
                                            for (final workload
                                                in (widget.schedule[getDay(page, day).dateOnly])
                                                        ?.map((e) => e.workload)
                                                        .flattened ??
                                                    <WorkloadTimeSlot>[])
                                              Builder(
                                                builder: (context) {
                                                  final offset = getIntervalPosition(
                                                    workload.timeInterval,
                                                    dayWidth,
                                                  );
                                                  return Positioned(
                                                    top: offset.dy,
                                                    left: offset.dx,
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior.translucent,
                                                      onTap: () {
                                                        widget.onWorkloadSelected(workload);
                                                        setState(() {
                                                          if (workload is FreeTimeWorkloadTimeSlot) {
                                                            currentInterval = workload.timeInterval;
                                                          } else {
                                                            currentInterval = null;
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 2),
                                                        child: Container(
                                                          height: getIntervalHeight(workload.timeInterval),
                                                          width: dayWidth - 4,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(16),
                                                            border:
                                                                workload == widget.selectedWorkLoad
                                                                    ? Border.all(
                                                                      color: Theme.of(context).colorScheme.outline,
                                                                      width: 2,
                                                                    )
                                                                    : null,
                                                            color: switch (workload) {
                                                              FreeTimeWorkloadTimeSlot() => Colors.grey,
                                                              RecordWorkloadTimeSlot slot =>
                                                                slot.recordInfo.status.color(),
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          if (currentInterval != null)
                                            AnimatedPositioned(
                                              duration: const Duration(milliseconds: 100),
                                              left: ((drawingInterval!.start.weekday - 1) % 7) * dayWidth - 24,
                                              top:
                                                  height *
                                                      (drawingInterval!.start.hour +
                                                          drawingInterval!.start.minute / 60) -
                                                  24,
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onVerticalDragStart: (_) {
                                                  fullDelta = 0;
                                                  currentDragInterval = currentInterval;
                                                },
                                                onVerticalDragUpdate: (details) {
                                                  fullDelta += details.delta.dy;
                                                  final newStart = currentInterval!.start.add(
                                                    Duration(minutes: fullDelta ~/ (height ~/ 4) * 15),
                                                  );
                                                  final newEnd = currentInterval!.end.add(
                                                    Duration(minutes: fullDelta ~/ (height ~/ 4) * 15),
                                                  );
                                                  if (!DateUtils.isSameDay(newStart, newEnd)) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    currentDragInterval = TimeInterval(
                                                      start: newStart,
                                                      end: newEnd,
                                                    );
                                                  });
                                                },
                                                onVerticalDragEnd: (_) {
                                                  fullDelta = 0;
                                                  setState(() {
                                                    currentInterval = currentDragInterval;
                                                    currentDragInterval = null;
                                                  });
                                                },
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(24),
                                                      child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 100),
                                                        height:
                                                            height *
                                                                (drawingInterval!.end.hour +
                                                                    drawingInterval!.end.minute / 60) -
                                                            height *
                                                                (drawingInterval!.start.hour +
                                                                    drawingInterval!.start.minute / 60),
                                                        width: dayWidth,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Theme.of(context).colorScheme.primaryContainer,
                                                            width: 2,
                                                          ),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 16,
                                                      top: 0,
                                                      child: GestureDetector(
                                                        behavior: HitTestBehavior.translucent,
                                                        onVerticalDragStart: (_) {
                                                          fullDelta = 0;
                                                          currentDragInterval = currentInterval;
                                                        },
                                                        onVerticalDragUpdate: (details) {
                                                          fullDelta += details.delta.dy;
                                                          final newStart = currentInterval!.start.add(
                                                            Duration(minutes: fullDelta ~/ (height ~/ 4) * 15),
                                                          );
                                                          if (!DateUtils.isSameDay(
                                                            newStart,
                                                            currentDragInterval!.end,
                                                          )) {
                                                            return;
                                                          }
                                                          if (newStart.isAfter(currentDragInterval!.end) ||
                                                              newStart.isAtSameMomentAs(currentDragInterval!.end)) {
                                                            return;
                                                          }

                                                          setState(() {
                                                            currentDragInterval = TimeInterval(
                                                              start: newStart,
                                                              end: currentInterval!.end,
                                                            );
                                                          });
                                                        },
                                                        onVerticalDragEnd: (_) {
                                                          fullDelta = 0;
                                                          setState(() {
                                                            currentInterval = currentDragInterval;
                                                            currentDragInterval = null;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(20),
                                                          child: Container(
                                                            width: 12,
                                                            height: 12,
                                                            padding: const EdgeInsets.all(4),
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).colorScheme.primaryContainer,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Theme.of(context).colorScheme.outline,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 16,
                                                      bottom: 0,
                                                      child: GestureDetector(
                                                        behavior: HitTestBehavior.translucent,
                                                        onVerticalDragStart: (_) {
                                                          fullDelta = 0;
                                                          currentDragInterval = currentInterval;
                                                        },
                                                        onVerticalDragUpdate: (details) {
                                                          fullDelta += details.delta.dy;
                                                          final newEnd = currentInterval!.end.add(
                                                            Duration(minutes: fullDelta ~/ (height ~/ 4) * 15),
                                                          );
                                                          if (!DateUtils.isSameDay(
                                                            newEnd,
                                                            currentDragInterval!.start,
                                                          )) {
                                                            return;
                                                          }
                                                          if (newEnd.isBefore(currentDragInterval!.start) ||
                                                              newEnd.isAtSameMomentAs(currentDragInterval!.start)) {
                                                            return;
                                                          }
                                                          setState(() {
                                                            currentDragInterval = TimeInterval(
                                                              start: currentInterval!.start,
                                                              end: newEnd,
                                                            );
                                                          });
                                                        },
                                                        onVerticalDragEnd: (_) {
                                                          fullDelta = 0;
                                                          setState(() {
                                                            currentInterval = currentDragInterval;
                                                            currentDragInterval = null;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.all(20),
                                                          child: Container(
                                                            width: 12,
                                                            height: 12,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).colorScheme.primaryContainer,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Theme.of(context).colorScheme.outline,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.isLoading) Positioned.fill(child: Center(child: CircularProgressIndicator())),
                  ],
                ),
          ),
        ),
      ],
    );
  }

  double fullDelta = 0;
}

class DayWidget extends StatelessWidget {
  final DateTime date;

  const DayWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('EE', Localizations.localeOf(context).languageCode);
    return SizedBox(
      width: 64,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 4,
            children: [
              Text(
                format.format(date).toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(date.day.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class HourWidget extends StatelessWidget {
  final int hour;
  final double height;

  const HourWidget({super.key, required this.hour, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hour > 0 ? height : height - 20,
      width: 48,
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(left: 4, right: 4),
      child:
          hour > 0
              ? Text(
                '$hour:00',
                textAlign: TextAlign.end,
                style: TextStyle(leadingDistribution: TextLeadingDistribution.even),
              )
              : null,
    );
  }
}
