import 'package:intl/intl.dart';

extension StringUtil on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String getWeekdayName(int weekday, [String format = 'EEEE']) {
  final DateTime now = DateTime.now().toLocal();
  final int diff = now.weekday - weekday; // weekday is our 1-7 ISO value
  DateTime udpatedDt;
  if (diff > 0) {
    udpatedDt = now.subtract(Duration(days: diff));
  } else if (diff == 0) {
    udpatedDt = now;
  } else {
    udpatedDt = now.add(Duration(days: diff * -1));
  }
  final String weekdayName = DateFormat(format).format(udpatedDt);
  return weekdayName;
}
