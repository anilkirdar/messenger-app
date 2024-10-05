import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../pages/chat_page.dart';

class ChatWidget extends StatelessWidget {
  final UserModel currentUser;
  final UserModel otherUser;
  final String titleText;
  final String subtitleText;
  final String timeText;
  const ChatWidget({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.titleText,
    required this.subtitleText,
    this.timeText = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => ChatPage(
            currentUser: currentUser,
            otherUser: otherUser,
          ),
        ));
      },
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleText, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              timeText,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
            ),
          ],
        ),
        subtitle:
            Text(subtitleText, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(otherUser.profilePhotoURL!),
        ),
      ),
    );
  }
}
