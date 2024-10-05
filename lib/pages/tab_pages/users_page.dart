import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../models/user_model.dart';
import '../chat_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final int countOfWillBeFetchedUserCount = 12;
  final ScrollController _scrollController = ScrollController();
  late bool _hasMore;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initStateMethods();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.watch<UserViewModelBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: userViewModelBloc.userList == null
            ? const Center(child: CircularProgressIndicator())
            : userViewModelBloc.userList!.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: userViewModelBloc.userList!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == userViewModelBloc.userList!.length) {
                        if (userViewModelBloc.state
                                is UserViewModelUserDBBusyState &&
                            _hasMore) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 12, top: 6),
                            child: Align(
                              widthFactor: 1,
                              child: CircularProgressIndicator(
                                color: Colors.black54,
                              ),
                            ),
                          );
                        } else {
                          _hasMore = false;
                          return null;
                        }
                      } else {
                        UserModel otherUser =
                            userViewModelBloc.userList![index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(CupertinoPageRoute(
                              builder: (context) => ChatPage(
                                currentUser: userViewModelBloc.user!,
                                otherUser: otherUser,
                              ),
                            ));
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
                              style: const TextStyle(color: Colors.black54),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(otherUser.profilePhotoURL!),
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
                          size: MediaQuery.of(context).size.height / 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No users found!',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: MediaQuery.of(context).size.height / 50,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  void initStateMethods() {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    getUserList();
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent -
                    MediaQuery.of(context).size.height / 10 &&
            !_scrollController.position.outOfRange) {
          getUserList(user: userViewModelBloc.userList!.last);
        }
      },
    );
  }

  void getUserList({UserModel? user}) async {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(
      GetUsersEvent(
        user: user ?? userViewModelBloc.user!,
        countOfWillBeFetchedUserCount: countOfWillBeFetchedUserCount,
      ),
    );
  }
}
