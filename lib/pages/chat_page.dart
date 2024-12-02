import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
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
  // final _userRepostiory = locator.get<UserRepository>();
  List<MessageModel>? _messageList;
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  StreamSubscription? _streamSubscription;
  final int _countOfWillBeFetchedMessageCount = 15;
  late bool _hasMore;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _hasMore = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getMessageList(isInitFunction: true);
        // activateMessageListener(
        //   currentUserID: widget.currentUser.userID,
        //   otherUserID: widget.otherUser.userID,
        // );
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
        backgroundColor: Colors.white,
        title: Text(
          widget.otherUser.userName!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListView.builder(
                            itemCount: _messageList!.length + 1,
                            reverse: true,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              if (index == _messageList!.length) {
                                if (userViewModelBloc.state
                                        is UserViewModelMessageDBBusyState &&
                                    _hasMore) {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 12, top: 6),
                                    child: Align(
                                      widthFactor: 1,
                                      child: CircularProgressIndicator(
                                          color: Consts.inactiveColor),
                                    ),
                                  );
                                } else {
                                  _hasMore = false;
                                  return null;
                                }
                              } else {
                                MessageModel message = _messageList![index];

                                return MessageBubble(
                                  message: message,
                                  currentUser: widget.currentUser,
                                  otherUser: widget.otherUser,
                                );
                              }
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // FaIcon(
                              //   FontAwesomeIcons.personCircleQuestion,
                              //   size: MediaQuery.of(context).size.height / 15,
                              //   color: Colors.black54,
                              // ),
                              // const SizedBox(height: 10),
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
                      backgroundColor: Consts.tertiaryAppColor,
                      child: const FaIcon(
                        FontAwesomeIcons.arrowUp,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          MessageModel message = MessageModel(
                            fromWho: widget.currentUser,
                            toWho: widget.otherUser,
                            message: _messageController.text.trim(),
                          );

                          _messageController.clear();

                          debugPrint(
                              '${widget.currentUser.userID}--${widget.otherUser.userID}');

                          userViewModelBloc.add(
                            SaveChatMessageEvent(
                              message: message,
                              resultCallBack: (result) {
                                if (result) {
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.easeOut,
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

  // Container(
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.rectangle,
  //                               color: Colors.black87,
  //                             ),
  //                             margin: EdgeInsets.only(),
  //                             height: size.height / 12,
  //                             width: size.width / (3 / 2),
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 FaIcon(
  //                                   FontAwesomeIcons.lock,
  //                                   color: Consts.primaryAppColor,
  //                                 ),
  //                                 Text(
  //                                   'All messages end-to-end encrypted. No one can see this chat.',
  //                                   style: TextStyle(
  //                                     color: Consts.primaryAppColor,
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 14,
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),

  void getMessageList({MessageModel? message, bool isInitFunction = false}) {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(GetMessagesEvent(
      currentUserID: widget.currentUser.userID,
      otherUserID: widget.otherUser.userID,
      message: message,
      countOfWillBeFetchedMessageCount: _countOfWillBeFetchedMessageCount,
      isInitFunction: isInitFunction,
    ));
  }

  // void activateMessageListener(
  //     {required String currentUserID, required String otherUserID}) {
  //   _streamSubscription = _userRepostiory
  //       .messageListener(
  //           currentUserID: currentUserID,
  //           otherUserID: otherUserID,
  //           context: context)
  //       .listen(
  //     (messageListFromStream) {
  //       if (messageListFromStream.isNotEmpty) {
  //         if (messageListFromStream[0] != null) {
  //           _messageList!.insert(0, messageListFromStream[0]!);
  //         }
  //       }
  //     },
  //   );
  // }
}
