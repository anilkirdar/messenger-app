import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts/consts.dart';
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
                backgroundColor: Colors.grey.withValues(alpha: 0.4),
                backgroundImage:
                    CachedNetworkImageProvider(otherUser.profilePhotoURL!),
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
                color: Consts.primaryAppColor,
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
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dateTimeFormatter(
                              message.createdAt?.toDate() ?? DateTime.now()),
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        // const SizedBox(width: 5),
                        // const FaIcon(
                        //   FontAwesomeIcons.check,
                        //   size: 14,
                        //   color: Colors.black54,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (message.isFromMe)
              CircleAvatar(
                backgroundColor: Colors.grey.withValues(alpha: 0.4),
                backgroundImage:
                    CachedNetworkImageProvider(currentUser.profilePhotoURL!),
                radius: 16,
              ),
          ],
        ),
      ),
    );
  }

  String _dateTimeFormatter(DateTime dateTime) {
    String formattedHour =
        dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour.toString();
    String formattedMinute = dateTime.minute < 10
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();
    return '$formattedHour.$formattedMinute';
  }
}
