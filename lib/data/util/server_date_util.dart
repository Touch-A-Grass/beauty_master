import 'package:intl/intl.dart';

extension ServerDateExtension on DateTime {
  String get serverDateOnly {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(this);
  }
}
