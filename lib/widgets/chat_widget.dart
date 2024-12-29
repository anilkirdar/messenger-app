import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  const ChatWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            chat.toWho.userName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            chat.lastMessageSentAt!,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Text(
        '${chat.lastMessageFromWho}: ${chat.lastMessage.message}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black54),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withValues(alpha: 0.4),
        backgroundImage:
            CachedNetworkImageProvider(chat.toWho.profilePhotoURL!),
      ),
    );
  }
}
