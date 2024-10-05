import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../locator.dart';
import '../../models/chat_model.dart';
import '../../repository/user_repository.dart';
import '../chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  @override
  Widget build(BuildContext context) {
    final userModelBloc = context.read<UserViewModelBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: FutureBuilder<List<ChatModel>>(
        future: _userRepository.getChats(currentUser: userModelBloc.user!),
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
                            currentUser: chat.currentUser,
                            otherUser: chat.otherUser,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chat.otherUser.userName!,
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
                          backgroundImage:
                              NetworkImage(chat.otherUser.profilePhotoURL!),
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
