part of 'order_details_widget.dart';

class _OrderRatingView extends StatelessWidget {
  final OrderReview review;

  const _OrderRatingView(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Отзыв клиента', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          RatingView(rating: review.rating, starSize: 24),
          if (review.comment.isNotEmpty) Text(review.comment, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
