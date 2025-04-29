import 'package:beauty_master/features/chat/presentation/components/unread_badge_container.dart';
import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onPressed;

  const ChatButton({super.key, required this.unreadCount, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: UnreadBadgeContainer(count: unreadCount, child: const Icon(Icons.chat_bubble_outline_rounded)),
    );
  }
}
