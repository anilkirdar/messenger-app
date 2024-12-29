import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../models/chat_model.dart';
import '../../widgets/chat_widget.dart';
import '../chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<ChatModel>? _chatList;
  List<ChatModel>? _filteredList;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  Widget _searchFieldIcon = SizedBox();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.watch<UserViewModelBloc>();
    final size = MediaQuery.of(context).size;

    if (userViewModelBloc.chatListStream == null) {
      userViewModelBloc.add(GetChatsEvent(countOfWillBeFetchedChatCount: 12));
    }

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Consts.backgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Consts.primaryAppColor, width: 3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: FaIcon(
                                FontAwesomeIcons.ellipsis,
                                color: Consts.primaryAppColor,
                                size: 14,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.clockRotateLeft,
                                color: Consts.primaryAppColor,
                                size: 22,
                              ),
                              SizedBox(width: 20),
                              FaIcon(
                                FontAwesomeIcons.penToSquare,
                                color: Consts.primaryAppColor,
                                size: 22,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Chats',
                        style: Consts.titleTextStyle,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 14,
                      child: SizedBox(
                        height: size.height / 20,
                        child: TextFormField(
                          autofocus: false,
                          // readOnly: _chatList == null ? true : false,
                          // canRequestFocus: _chatList == null ? false : true,
                          enableInteractiveSelection: false,
                          maxLines: 1,
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          // keyboardType: keyboardType,
                          onChanged: (value) {
                            if (_chatList != null) {
                              _filterItems(value, _chatList!);
                              if (value.isNotEmpty) {
                                _searchFieldIcon = IconButton(
                                  onPressed: () {
                                    _textEditingController.clear();
                                    _searchFieldIcon = SizedBox();
                                    setState(() {});
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.circleXmark,
                                    color: Consts.inactiveColor,
                                  ),
                                );
                              } else {
                                _searchFieldIcon = SizedBox();
                              }
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: _searchFieldIcon,
                            fillColor:
                                Consts.inactiveColor.withValues(alpha: 0.15),
                            filled: true,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: FaIcon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Consts.inactiveColor,
                                size: 20,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(maxWidth: 50),
                            label: Text(
                              'Search',
                              style: TextStyle(fontSize: 18),
                            ),
                            labelStyle: TextStyle(
                                color: Consts.inactiveColor,
                                fontWeight: FontWeight.bold),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: FaIcon(
                        FontAwesomeIcons.filter,
                        color: Consts.primaryAppColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<List<ChatModel>>(
                    stream: userViewModelBloc.chatListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _chatList = snapshot.data!;

                        if (_chatList!.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _filteredList != null
                                ? _filteredList!.isNotEmpty
                                    ? _filteredList!.length
                                    : _chatList!.length
                                : _chatList!.length,
                            itemBuilder: (context, index) {
                              ChatModel chat = _filteredList != null
                                  ? _filteredList!.isNotEmpty
                                      ? _filteredList![index]
                                      : _chatList![index]
                                  : _chatList![index];

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
                                child: ChatWidget(chat: chat),
                              );
                            },
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
                                "Couldn't find any chat.",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 50,
                                ),
                              ),
                            ],
                          ));
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Consts.inactiveColor),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _filterItems(String query, List<ChatModel> allItems) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = allItems;
      } else {
        _filteredList = allItems
            .where((item) => item.toWho.userName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
