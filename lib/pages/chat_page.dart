import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../locator.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../services/notification_service.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel otherUser;

  const ChatPage(
      {super.key, required this.currentUser, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel>? _messageList;
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  StreamSubscription? _streamSubscription;
  final int _countOfWillBeFetchedMessageCount = 15;
  late bool _hasMore;
  final UserRepository _userRepository = locator.get<UserRepository>();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _hasMore = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getMessageList(isInitFunction: true);
        _scrollController.addListener(
          () {
            if (_scrollController.positions.isNotEmpty) {
              if (_scrollController.offset >=
                      _scrollController.position.minScrollExtent &&
                  !_scrollController.position.outOfRange) {
                getMessageList(message: _messageList!.last);
              }
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModelBloc userViewModelBloc = context.watch<UserViewModelBloc>();
    _messageList = userViewModelBloc.messageList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.inactiveColor.withValues(alpha: 0.1),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.withValues(alpha: 0.4),
              backgroundImage:
                  CachedNetworkImageProvider(widget.otherUser.profilePhotoURL!),
              radius: 16,
            ),
            SizedBox(width: 10),
            Text(
              widget.otherUser.userName!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Consts.primaryAppColor,
              size: 30,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _messageList == null
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Consts.inactiveColor))
                  : _messageList!.isNotEmpty
                      ? StreamBuilder(
                          stream: _userRepository.messageListener(
                            currentUserID: widget.currentUser.userID,
                            otherUserID: widget.otherUser.userID,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.zero,
                                child: ListView.builder(
                                  itemCount: _messageList!.length + 1,
                                  reverse: true,
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    final reversedIndex =
                                        _messageList!.length - 1 - index;

                                    if (index == _messageList!.length) {
                                      if (userViewModelBloc.state
                                              is UserViewModelMessageDBBusyState &&
                                          _hasMore) {
                                        return const Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 12,
                                            top: 6,
                                          ),
                                          child: Align(
                                            widthFactor: 1,
                                            child: CircularProgressIndicator(
                                                color: Consts.inactiveColor),
                                          ),
                                        );
                                      } else {
                                        _hasMore = false;
                                        return const SizedBox.shrink();
                                      }
                                    } else {
                                      MessageModel message =
                                          _messageList![reversedIndex];

                                      DateTime messageTime =
                                          message.createdAt!.toDate();

                                      DateTime? previousMessageTime =
                                          reversedIndex > 0
                                              ? _messageList![reversedIndex - 1]
                                                  .createdAt!
                                                  .toDate()
                                              : null;

                                      bool showDateHeader =
                                          previousMessageTime == null ||
                                              getFormattedDate(messageTime) !=
                                                  getFormattedDate(
                                                      previousMessageTime);

                                      return Column(
                                        children: [
                                          if (showDateHeader)
                                            Text(
                                              getFormattedDate(messageTime),
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          MessageBubble(
                                            message: message,
                                            currentUser: widget.currentUser,
                                            otherUser: widget.otherUser,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Come on, chat a little.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 8, left: 8, top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type your message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Consts.primaryAppColor,
                      child: const FaIcon(
                        FontAwesomeIcons.arrowUp,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          MessageModel message = MessageModel(
                              message: _messageController.text.trim());

                          _messageController.clear();

                          userViewModelBloc.add(
                            SaveChatMessageEvent(
                              message: message,
                              otherUser: widget.otherUser,
                              resultCallBack: (result) {
                                if (result &&
                                    _scrollController.positions.isNotEmpty) {
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.easeOut,
                                  );

                                  NotificationService.sendNotification(
                                    currentUser: widget.currentUser,
                                    messageToBeSent: message.message,
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMessageList({MessageModel? message, bool isInitFunction = false}) {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(GetMessagesEvent(
      otherUserID: widget.otherUser.userID,
      message: message,
      countOfWillBeFetchedMessageCount: _countOfWillBeFetchedMessageCount,
      isInitFunction: isInitFunction,
    ));
  }

  String getFormattedDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (date.isAfter(today)) {
      return "Today";
    } else if (date.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('EEEE').format(date);
    }
  }
}
