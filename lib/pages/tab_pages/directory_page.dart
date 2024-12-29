import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../models/user_model.dart';
import '../chat_page.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  late int _countOfWillBeFetchedUserCount;
  late ScrollController _scrollController;
  late bool _hasMore;
  List<UserModel>? _userList;
  List<UserModel>? _filteredList;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  Widget _searchFieldIcon = SizedBox();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _countOfWillBeFetchedUserCount = 15;
    _hasMore = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initStateMethods();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.watch<UserViewModelBloc>();
    _userList = userViewModelBloc.userList;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height / 15,
                  child: Text(
                    'Find People',
                    style: Consts.titleTextStyle,
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
                          enableInteractiveSelection: false,
                          maxLines: 1,
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            if (_userList != null) {
                              _filterItems(value, _userList!);
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
                  child: _userList == null
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Consts.inactiveColor))
                      : _userList!.isNotEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              itemCount: _filteredList != null
                                  ? _filteredList!.isNotEmpty
                                      ? _filteredList!.length
                                      : _userList!.length + 1
                                  : _userList!.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _userList!.length) {
                                  if (userViewModelBloc.state
                                          is UserViewModelUserDBBusyState &&
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
                                  UserModel otherUser = _filteredList != null
                                      ? _filteredList!.isNotEmpty
                                          ? _filteredList![index]
                                          : _userList![index]
                                      : _userList![index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        CupertinoPageRoute(
                                          builder: (context) => ChatPage(
                                            currentUser:
                                                userViewModelBloc.user!,
                                            otherUser: otherUser,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                        otherUser.userName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      subtitle: Text(
                                        otherUser.email,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                otherUser.profilePhotoURL!),
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.personCircleQuestion,
                                    size: size.height / 15,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'No users found!',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: size.height / 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initStateMethods() {
    getUserList();
    _scrollController.addListener(
      () {
        if (_scrollController.positions.isNotEmpty) {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange) {
            getUserList(user: _userList!.last);
          }
        }
      },
    );
  }

  void getUserList({UserModel? user}) async {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(
      GetUsersEvent(
        user: user ?? userViewModelBloc.user!,
        countOfWillBeFetchedUserCount: _countOfWillBeFetchedUserCount,
      ),
    );
  }

  void _filterItems(String query, List<UserModel> allItems) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = allItems;
      } else {
        _filteredList = allItems
            .where((item) =>
                item.userName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
