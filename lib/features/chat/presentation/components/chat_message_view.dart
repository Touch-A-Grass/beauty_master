part of 'chat_view.dart';

class ChatMessageView extends StatefulWidget {
  final ChatMessage message;
  final bool showAvatar;

  const ChatMessageView({super.key, required this.message, required this.showAvatar});

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final dateFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          textDirection: widget.message.participant.isOwner ? TextDirection.rtl : TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            if (widget.showAvatar)
              SizedBox.square(
                dimension: 40,
                child: CircleAvatar(
                  foregroundImage:
                      widget.message.participant.avatar != null
                          ? CachedNetworkImageProvider(ImageUtil.parse256(widget.message.participant.avatar!))
                          : null,
                  child: Text(widget.message.participant.initials),
                ),
              )
            else
              SizedBox.square(dimension: 40),
            Flexible(
              child: IntrinsicWidth(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color:
                            !widget.message.participant.isOwner
                                ? Theme.of(context).colorScheme.surfaceContainer
                                : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            !widget.message.participant.isOwner
                                ? BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                  bottomLeft: widget.showAvatar ? Radius.zero : Radius.circular(16),
                                )
                                : BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomRight: widget.showAvatar ? Radius.zero : Radius.circular(16),
                                ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.message.text,
                        textAlign: widget.message.participant.isOwner ? TextAlign.right : TextAlign.left,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              !widget.message.participant.isOwner
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    if (widget.showAvatar)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Text(
                            dateFormat.format(widget.message.createdAt),
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                          Icon(
                            !widget.message.isSent
                                ? Icons.schedule_rounded
                                : widget.message.isRead
                                ? Icons.done_all
                                : Icons.done,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
