part of 'order_details_widget.dart';

class _OrderInfoItem extends StatelessWidget {
  final Widget title;
  final Widget value;

  const _OrderInfoItem(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, value],
      ),
    );
  }
}
