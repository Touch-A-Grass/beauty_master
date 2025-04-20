part of 'orders_widget.dart';

class _OrderCalendar extends StatefulWidget {
  final CalendarMonthStatus? monthStatus;
  final DateTime selectedDay;
  final DateTime selectedMonth;
  final void Function(DateTime) onDateSelected;
  final void Function(DateTime) onMonthSelected;

  const _OrderCalendar({
    required this.monthStatus,
    required this.selectedDay,
    required this.selectedMonth,
    required this.onDateSelected,
    required this.onMonthSelected,
  });

  @override
  State<_OrderCalendar> createState() => _OrderCalendarState();
}

class _OrderCalendarState extends State<_OrderCalendar> {
  final monthFormat = DateFormat.MMMM();
  final dayFormat = DateFormat.d();

  @override
  Widget build(BuildContext context) {
    var firstDay = DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);

    while (firstDay.weekday != 1) {
      firstDay = firstDay.subtract(const Duration(days: 1));
    }

    var day = firstDay;
    final days = <DateTime>[];
    final lastDay = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0).add(const Duration(days: 1));

    while (!DateUtils.isSameDay(day, lastDay)) {
      days.add(day);
      day = day.add(const Duration(days: 1));
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 250),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed:
                      () =>
                          widget.onMonthSelected(widget.selectedMonth.copyWith(month: widget.selectedMonth.month - 1)),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    monthFormat.format(widget.selectedMonth).capitalize(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed:
                      () =>
                          widget.onMonthSelected(widget.selectedMonth.copyWith(month: widget.selectedMonth.month + 1)),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Stack(
              children: [
                GridView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                  children: List.generate(days.length, (index) {
                    final day = days[index];

                    if (day.month != widget.selectedMonth.month) {
                      return Container(height: 50);
                    }

                    final isSelectedDay = DateUtils.isSameDay(widget.selectedDay, day);
                    final isToday = DateUtils.isSameDay(DateTime.now(), day);

                    if (widget.monthStatus == null) {
                      return Container(height: 50);
                    }

                    return ShimmerLoadingPainter(
                      active: widget.monthStatus == null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              isSelectedDay
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : widget.monthStatus == null
                                  ? Theme.of(context).colorScheme.surface
                                  : switch (widget.monthStatus!.getDayStatus(day.day)) {
                                    CalendarDayStatus.noOrders => null,
                                    _ => Theme.of(context).colorScheme.surface,
                                  },
                          borderRadius: BorderRadius.circular(8),
                          border: isToday ? Border.all(color: Theme.of(context).colorScheme.primaryContainer) : null,
                        ),
                        padding: EdgeInsets.all(4),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => widget.onDateSelected(day),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  dayFormat.format(day),
                                  style: TextStyle(
                                    color: isSelectedDay ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: switch (widget.monthStatus?.getDayStatus(day.day) ??
                                        CalendarDayStatus.noOrders) {
                                      CalendarDayStatus.noOrders => Colors.transparent,
                                      CalendarDayStatus.newOrders => Colors.orange.withValues(alpha: 0.7),
                                      CalendarDayStatus.approved => Colors.green.withValues(alpha: 0.7),
                                      CalendarDayStatus.completed => Colors.transparent,
                                    },
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                if (widget.monthStatus == null) Positioned.fill(child: Center(child: CircularProgressIndicator())),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
