import 'package:auto_route/annotations.dart';
import 'package:beauty_master/presentation/screens/calendar/bloc/calendar_bloc.dart';
import 'package:beauty_master/presentation/screens/calendar/widget/calendar_widget.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: BlocProvider(
        create: (context) => CalendarBloc(context.read(), context.read(), context.read())..add(CalendarEvent.started()),
        child: CalendarWidget(),
      ),
    );
  }
}
