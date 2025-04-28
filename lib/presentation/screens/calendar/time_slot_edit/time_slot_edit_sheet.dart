import 'package:beauty_master/domain/models/time_interval.dart';
import 'package:beauty_master/domain/models/workload_time_slot.dart';
import 'package:beauty_master/presentation/screens/calendar/time_slot_edit/bloc/time_slot_edit_bloc.dart';
import 'package:beauty_master/presentation/screens/calendar/time_slot_edit/widget/time_slot_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotEditSheet extends StatelessWidget {
  final FreeTimeWorkloadTimeSlot? timeSlot;
  final VoidCallback onClose;
  final TimeInterval? newInterval;
  final ValueChanged<String> onConfirm;
  final VoidCallback? onDelete;

  const TimeSlotEditSheet({
    super.key,
    this.timeSlot,
    required this.onClose,
    this.newInterval,
    required this.onConfirm,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              TimeSlotEditBloc(context.read(), context.read(), timeSlot: timeSlot)
                ..add(const TimeSlotEditEvent.started()),
      child: _TimeSlotListener(
        onClose: onClose,
        onConfirm: onConfirm,
        onDelete: onDelete,
        newInterval: newInterval,
        timeSlot: timeSlot,
      ),
    );
  }
}

class _TimeSlotListener extends StatefulWidget {
  final FreeTimeWorkloadTimeSlot? timeSlot;
  final VoidCallback onClose;
  final TimeInterval? newInterval;
  final  ValueChanged<String>  onConfirm;
  final VoidCallback? onDelete;

  const _TimeSlotListener({
    required this.timeSlot,
    required this.onClose,
    required this.newInterval,
    required this.onConfirm,
    required this.onDelete,
  });

  @override
  State<_TimeSlotListener> createState() => _TimeSlotListenerState();
}

class _TimeSlotListenerState extends State<_TimeSlotListener> {
  @override
  void didUpdateWidget(covariant _TimeSlotListener oldWidget) {
    if (oldWidget.timeSlot != widget.timeSlot) {
      context.read<TimeSlotEditBloc>().add(TimeSlotEditEvent.reset(widget.timeSlot));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TimeSlotEditWidget(
      onClose: widget.onClose,
      onConfirm: widget.onConfirm,
      onDelete: widget.onDelete,
      newInterval: widget.newInterval,
    );
  }
}
