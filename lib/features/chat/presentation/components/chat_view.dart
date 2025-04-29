import 'package:beauty_master/features/chat/domain/models/chat_event.dart';
import 'package:beauty_master/features/chat/domain/models/chat_message.dart';
import 'package:beauty_master/presentation/util/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

part 'chat_message_view.dart';

class ChatView extends StatefulWidget {
  final List<ChatEvent> events;
  final ValueChanged<String>? onSend;

  const ChatView({super.key, required this.events, required this.onSend});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            slivers: [
              if (widget.events.isNotEmpty)
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16) +
                      EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) {
                      final event = widget.events[index];
                      final prevEvent = index == 0 ? null : widget.events[index - 1];
                      return switch (event) {
                        MessageChatEvent() => ChatMessageView(
                          message: event.message,
                          showAvatar:
                              index == 0 ||
                              prevEvent is! MessageChatEvent ||
                              prevEvent.message.participant.id != event.message.participant.id ||
                              prevEvent.message.createdAt.difference(event.message.createdAt) >
                                  const Duration(minutes: 2),
                        ),
                        StatusLogChatEvent() => Center(child: Text(event.log.text, textAlign: TextAlign.center)),
                      };
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemCount: widget.events.length,
                  ),
                )
              else
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Нет сообщений\nНапишите первым', textAlign: TextAlign.center)),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: TextFormField(
            maxLines: 5,
            maxLength: 2000,
            minLines: 1,
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              counterText: '',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed:
                    widget.onSend == null || controller.text.trim().isEmpty
                        ? null
                        : () {
                          widget.onSend?.call(controller.text.trim());
                          controller.clear();
                        },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
