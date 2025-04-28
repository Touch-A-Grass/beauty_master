import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_review.freezed.dart';
part 'order_review.g.dart';

@freezed
class OrderReview with _$OrderReview {
  const factory OrderReview({@Default('') String comment, required int rating}) = _OrderReview;

  factory OrderReview.fromJson(Map<String, dynamic> json) => _$OrderReviewFromJson(json);
}
