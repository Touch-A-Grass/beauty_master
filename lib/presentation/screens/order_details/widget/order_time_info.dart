part of 'order_details_widget.dart';

class _OrderTimeInfo extends StatefulWidget {
  final Order order;

  const _OrderTimeInfo({required this.order});

  @override
  State<_OrderTimeInfo> createState() => _OrderTimeInfoState();
}

class _OrderTimeInfoState extends State<_OrderTimeInfo> {
  final dateFormatter = DateFormat('dd MMMM HH:mm');
  final endTimeFormatter = DateFormat('HH:mm');

  final calendarFormatter = DateFormat('yyyyMMddTHHmmss');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OrderInfoItem(
          Text(S.of(context).orderDate),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => launchUrl(Uri.parse(generateLink())),
            child: Text(
              dateFormatter.format(widget.order.startTimestamp.toLocal()),
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }

  String generateLink() {
    return 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=${S.of(context).calendarRecordText(widget.order.venue.name, widget.order.service.name).replaceAll(' ', '+')}&dates=${calendarFormatter.format(widget.order.startTimestamp.toLocal())}/${calendarFormatter.format(widget.order.endTimestamp.toLocal())}';
  }
}
