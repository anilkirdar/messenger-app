import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../models/chat_model.dart';
import 'chat_page.dart';
import 'tab_pages/users_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.watch<UserViewModelBloc>();

    if (userViewModelBloc.chatListStream == null) {
      userViewModelBloc.add(GetChatsEvent(
          currentUser: userViewModelBloc.user!,
          countOfWillBeFetchedChatCount: 12));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Consts.primaryAppColor,
        elevation: 2,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => UsersPage(),
          ));
        },
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.black54,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: userViewModelBloc.chatListStream != null
          ? StreamBuilder<List<ChatModel>>(
              stream: userViewModelBloc.chatListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatModel> chatList = snapshot.data!;

                  if (chatList.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          ChatModel chat = chatList[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(CupertinoPageRoute(
                                builder: (context) => ChatPage(
                                  currentUser: chat.fromWho,
                                  otherUser: chat.toWho,
                                ),
                              ))
                                  .then(
                                (value) {
                                  setState(() {});
                                },
                              );
                            },
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    chat.messageLastSeenAt!,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${chat.lastMessageFromWho}: ${chat.lastMessage}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black54),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.withAlpha(40),
                                backgroundImage: CachedNetworkImageProvider(
                                    chat.toWho.profilePhotoURL!),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.personCircleQuestion,
                          size: MediaQuery.of(context).size.height / 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Couldn't find any messages.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: MediaQuery.of(context).size.height / 50,
                          ),
                        ),
                      ],
                    ));
                  }
                } else {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: Consts.inactiveColor),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(color: Consts.inactiveColor)),
    );
  }

  // getStream({required UserViewModelBloc userViewModelBloc}) async {
  //   return await _userRepository.getChats(
  //     currentUser: userViewModelBloc.user!,
  //     countOfWillBeFetchedChatCount: 12,
  //   );
  // }
}
