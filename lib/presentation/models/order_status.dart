import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/generated/l10n.dart';
import 'package:flutter/material.dart';

extension OrderStatusUi on OrderStatus {
  String statusName(BuildContext context) => switch (this) {
    OrderStatus.discarded => S.of(context).orderStatusDiscarded,
    OrderStatus.pending => S.of(context).orderStatusPending,
    OrderStatus.approved => S.of(context).orderStatusApproved,
    OrderStatus.completed => S.of(context).orderStatusCompleted,
  };

  Color color() => switch (this) {
    OrderStatus.discarded => Colors.red.withValues(alpha: 0.7),
    OrderStatus.pending => Colors.orange.withValues(alpha: 0.7),
    OrderStatus.approved => Colors.green.withValues(alpha: 0.7),
    OrderStatus.completed => Colors.blue.withValues(alpha: 0.7),
  };
}
