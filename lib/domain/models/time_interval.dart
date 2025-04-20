import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_interval.freezed.dart';
part 'time_interval.g.dart';

@freezed
class TimeInterval with _$TimeInterval {
  const factory TimeInterval({required DateTime start, required DateTime end}) = _TimeInterval;

  factory TimeInterval.fromJson(Map<String, dynamic> json) => _$TimeIntervalFromJson(json);
}
