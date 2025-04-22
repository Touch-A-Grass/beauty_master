import 'package:beauty_master/domain/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workload_order_info.freezed.dart';
part 'workload_order_info.g.dart';

@freezed
class WorkloadOrderInfo with _$WorkloadOrderInfo {
  const factory WorkloadOrderInfo({
    required String id,
    required OrderStatus status,
    required String clientName,
    required String serviceName,
  }) = _WorkloadOrderInfo;

  factory WorkloadOrderInfo.fromJson(Map<String, dynamic> json) => _$WorkloadOrderInfoFromJson(json);
}
