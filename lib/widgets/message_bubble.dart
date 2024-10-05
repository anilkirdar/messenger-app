import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final UserModel currentUser;
  final UserModel otherUser;

  const MessageBubble(
      {super.key,
      required this.message,
      required this.currentUser,
      required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          right: message.isFromMe ? 8 : 0,
          left: message.isFromMe ? 0 : 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isFromMe)
              CircleAvatar(
                backgroundColor: Colors.grey.withAlpha(40),
                backgroundImage: NetworkImage(otherUser.profilePhotoURL!),
                radius: 16,
              ),
            Container(
              margin: EdgeInsets.only(
                bottom: 5,
                right: message.isFromMe ? 10 : 0,
                left: message.isFromMe ? 0 : 10,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 3),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.message,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dateTimeFormatter(
                              message.createdAt ?? Timestamp(1, 1)),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const FaIcon(
                          FontAwesomeIcons.check,
                          size: 14,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (message.isFromMe)
              CircleAvatar(
                backgroundColor: Colors.grey.withAlpha(40),
                backgroundImage: NetworkImage(currentUser.profilePhotoURL!),
                radius: 16,
              ),
          ],
        ),
      ),
    );
  }

  String _dateTimeFormatter(Timestamp timestamp) {
    DateFormat formatter = DateFormat.Hm();
    var formattedTime = formatter.format(timestamp.toDate());
    return formattedTime;
  }
}
