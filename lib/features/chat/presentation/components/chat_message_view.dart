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

  bool checkedUrl = false;
  bool isImage = true;

  Future<bool> validateImage(String imageUrl) async {
    if (!(Uri.tryParse(imageUrl)?.isAbsolute ?? true)) return false;
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }
    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }

  void check(BuildContext context) async {
    if (widget.message.info.content is TextChatMessageContent) {
      final textContent = widget.message.info.content as TextChatMessageContent;
      final cached = context.read<ImageUrlCache>().value[textContent.text];
      isImage = cached ?? await validateImage(textContent.text);
      if (context.mounted) {
        final value = Map.of(context.read<ImageUrlCache>().value);
        value[textContent.text] = isImage;
        context.read<ImageUrlCache>().value = value;
      }
    }
    if (context.mounted) {
      setState(() {
        checkedUrl = true;
      });
    }
  }

  @override
  void initState() {
    check(context);
    super.initState();
  }

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
                    switch (widget.message.info.content) {
                      TextChatMessageContent content =>
                      isImage
                          ? _ImageView(
                        CachedNetworkImageProvider(content.text),
                        widget.showAvatar,
                        widget.message.participant.isOwner,
                        content.text,
                      )
                          : _TextView(content.text, widget.showAvatar, widget.message.participant.isOwner),
                      ImageChatMessageContent content => _ImageView(
                        MemoryImage(content.bytes),
                        widget.showAvatar,
                        widget.message.participant.isOwner,
                        null,
                      ),
                    },

                    if (widget.showAvatar)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Text(
                            dateFormat.format(widget.message.info.createdAt),
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                          Icon(
                            !widget.message.isSent
                                ? Icons.schedule_rounded
                                : widget.message.info.isRead
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

class _MessageContainer extends StatelessWidget {
  final Widget child;
  final bool showAvatar;
  final bool isOwner;

  const _MessageContainer({required this.child, required this.showAvatar, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color:
        !isOwner ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.primaryContainer,
        borderRadius:
        !isOwner
            ? BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topLeft: Radius.circular(16),
          bottomLeft: showAvatar ? Radius.zero : Radius.circular(16),
        )
            : BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: showAvatar ? Radius.zero : Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _TextView extends StatelessWidget {
  final String text;
  final bool showAvatar;
  final bool isOwner;

  const _TextView(this.text, this.showAvatar, this.isOwner);

  @override
  Widget build(BuildContext context) {
    return _MessageContainer(
      showAvatar: showAvatar,
      isOwner: isOwner,
      child: Text(
        text,
        textAlign: isOwner ? TextAlign.right : TextAlign.left,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: !isOwner ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  final ImageProvider imageProvider;
  final bool showAvatar;
  final bool isOwner;
  final String? imageUrl;

  const _ImageView(this.imageProvider, this.showAvatar, this.isOwner, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return _MessageContainer(
      showAvatar: showAvatar,
      isOwner: isOwner,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: () {
            if (imageUrl != null) {
              launchUrl(Uri.parse(imageUrl!));
            }
          },
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
            imageUrl != null
                ? Text(
              imageUrl!,
              textAlign: isOwner ? TextAlign.right : TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                !isOwner
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )
                : const Icon(Icons.error),
            loadingBuilder:
                (context, child, loadingProgress) =>
            loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
