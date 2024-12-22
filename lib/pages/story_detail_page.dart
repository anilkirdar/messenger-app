import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_time/story_time.dart';

import '../bloc/user_view_model_bloc.dart';
import '../consts/consts.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';

class StoryDetailPage extends StatefulWidget {
  final int currentStoryIndex;
  final List<StoryModel?> storyList;
  const StoryDetailPage(
      {super.key, required this.currentStoryIndex, required this.storyList});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late ValueNotifier<IndicatorAnimationCommand> _controller;
  late List<StoryModel?> _willUsedList;
  late bool _isStoryPaused;
  final _firestoreDB = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _isStoryPaused = false;
    _controller = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand(resume: !_isStoryPaused, pause: _isStoryPaused),
    );
    _controller.value = IndicatorAnimationCommand(
      duration: const Duration(seconds: 2),
    );
    _willUsedList = [];
    _willUsedList.addAll(widget.storyList);
    if (widget.storyList[0]!.storyDetailsList!.isEmpty) {
      _willUsedList.removeAt(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelBloc = context.read<UserViewModelBloc>();

    return SafeArea(
      child: Scaffold(
        body: StoryPageView(
          initialPage: widget.currentStoryIndex,
          pageLength: _willUsedList.length,
          storyLength: (int pageIndex) {
            return _willUsedList[pageIndex]!.storyDetailsList!.length;
          },
          itemBuilder: (context, pageIndex, storyIndex) {
            final StoryModel storyModel = _willUsedList[pageIndex]!;
            final UserModel user = storyModel.user;
            final Map<String, dynamic> story =
                storyModel.storyDetailsList![storyIndex];

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Color(story['dominantColor'] ?? 0x00000000),
                  ),
                ),
                Positioned.fill(child: Image.network(story['storyPhotoUrl'])),
                _isStoryPaused
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 44, left: 8),
                        child: Row(
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      user.profilePhotoURL!),
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.userName!,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              getTimeDifference(story['createdAt']),
                              style: TextStyle(
                                color: Consts.inactiveColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
          gestureItemBuilder: (context, pageIndex, storyIndex) {
            return _isStoryPaused
                ? SizedBox()
                : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
          },
          indicatorAnimationController: _controller,
          onPageForward: (newPageIndex) {
            addSeenList(
              userViewModelBloc: userViewModelBloc,
              newPageIndex: newPageIndex,
            );
          },
          onPageLimitReached: () {
            addSeenList(userViewModelBloc: userViewModelBloc);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  String getTimeDifference(Timestamp storyCreatedAtTimestamp) {
    DateTime currentDateTime = DateTime.now();
    DateTime storyCreatedAt = storyCreatedAtTimestamp.toDate();
    Duration timeDifference = currentDateTime.difference(storyCreatedAt);

    if (timeDifference.inMinutes < 1) {
      return '0m';
    } else if (timeDifference.inHours < 1) {
      return '${timeDifference.inMinutes}m';
    } else {
      return '${timeDifference.inHours}h';
    }
  }

  void addSeenList(
      {required UserViewModelBloc userViewModelBloc, int? newPageIndex}) async {
    StoryModel? currentStory = newPageIndex != null
        ? _willUsedList[newPageIndex - 1]
        : _willUsedList.last;

    if (!currentStory!.listOfUsersHaveSeen!
            .contains(userViewModelBloc.user!.userID) &&
        userViewModelBloc.user!.userID != currentStory.user.userID) {
      currentStory.listOfUsersHaveSeen!.add(userViewModelBloc.user!.userID);

      await _firestoreDB
          .collection('stories')
          .doc(currentStory.user.userID)
          .update({'listOfUsersHaveSeen': currentStory.listOfUsersHaveSeen});
    }
  }
}
