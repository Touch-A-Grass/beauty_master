part of 'order_details_widget.dart';

class _ClientProfileInfo extends StatefulWidget {
  final User user;

  const _ClientProfileInfo(this.user);

  @override
  State<_ClientProfileInfo> createState() => _ClientProfileInfoState();
}

class _ClientProfileInfoState extends State<_ClientProfileInfo> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 48,
            child: CircleAvatar(
              foregroundImage:
                  widget.user.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(widget.user.photo!)) : null,
              child: Text(widget.user.initials),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.user.name, textAlign: TextAlign.end),
                SelectableText(
                  phoneFormatter.maskText(widget.user.phoneNumber),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.end,
                  onTap: () => launchUrl(Uri.parse('tel:${widget.user.phoneNumber}')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
