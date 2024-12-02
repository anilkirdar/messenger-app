// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../models/story_model.dart';
import 'tab_pages/profile_page.dart';

// ignore: must_be_immutable
class StoryDetailPage extends StatefulWidget {
  final StoryModel story;
  int currentStoryIndex;
  StoryDetailPage(
      {super.key, required this.story, required this.currentStoryIndex});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late int currentStoryDetailIndex;
  final _firestoreDB = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentStoryDetailIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.read<UserViewModelBloc>();
    Size size = MediaQuery.of(context).size;
    StoryModel currentStory =
        userViewModelBloc.storyList![widget.currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Image.network(
                widget.story.storyDetailsList![currentStoryDetailIndex]
                    ['storyPhotoUrl'],
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (var i = 0;
                          i < widget.story.storyDetailsList!.length;
                          i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            color: currentStoryDetailIndex >= i
                                ? Colors.white
                                : Consts.inactiveColor,
                            height: 5,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(user: widget.story.user),
                          ));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.withAlpha(40),
                              backgroundImage: NetworkImage(
                                  widget.story.user.profilePhotoURL!),
                              radius: 16,
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.story.user.userName!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        getTimeDifference(widget.story
                                .storyDetailsList![currentStoryDetailIndex]
                            ['createdAt']),
                        style: TextStyle(
                          color: Consts.inactiveColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentStoryDetailIndex > 0) {
                        currentStoryDetailIndex -= 1;
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: size.height - (size.height / 5),
                      width: size.width / 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (currentStoryDetailIndex <
                          widget.story.storyDetailsList!.length - 1) {
                        currentStoryDetailIndex += 1;
                        setState(() {});
                      } else {
                        if (!currentStory.listOfUsersHaveSeen!
                                .contains(userViewModelBloc.user!.userID) &&
                            userViewModelBloc.user!.userID !=
                                currentStory.user.userID) {
                          currentStory.listOfUsersHaveSeen!
                              .add(userViewModelBloc.user!.userID);
    
                          await _firestoreDB
                              .collection('stories')
                              .doc(widget.story.user.userID)
                              .update({
                            'listOfUsersHaveSeen': userViewModelBloc
                                .storyList![widget.currentStoryIndex]
                                .listOfUsersHaveSeen!
                          });
                        }
    
                        if (userViewModelBloc.storyList!.length - 1 ==
                            widget.currentStoryIndex) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } else {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => StoryDetailPage(
                              story: userViewModelBloc
                                  .storyList![widget.currentStoryIndex + 1],
                              currentStoryIndex: widget.currentStoryIndex + 1,
                            ),
                          ));
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: size.height - (size.height / 5),
                      width: size.width / 2,
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

  String getTimeDifference(Timestamp storyCreatedAtTimestamp) {
    DateTime currentDateTime = DateTime.now();
    DateTime storyCreatedAt = storyCreatedAtTimestamp.toDate();
    Duration timeDifference = currentDateTime.difference(storyCreatedAt);

    if (timeDifference.inMinutes < 1) {
      return 'a moment ago';
    } else if (timeDifference.inHours < 1) {
      return '${timeDifference.inMinutes} minutes ago';
    } else {
      return '${timeDifference.inHours} hour ago';
    }
  }
}
