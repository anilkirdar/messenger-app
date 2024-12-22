import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';
import '../../widgets/story_detail_card_widget.dart';
import '../story_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _countOfWillBeFetchedStoryCount;
  late ScrollController _scrollController;
  late bool _hasMore;
  late ImagePicker _picker;
  XFile? _newPickedImage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _countOfWillBeFetchedStoryCount = 10;
    _hasMore = true;
    _picker = ImagePicker();
    getStories(isInitFunction: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupScrollController();
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Consts.backgroundColor,
      appBar: AppBar(
        backgroundColor: Consts.backgroundColor,
        title: const Text(
          'Chatrix',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: userViewModelBloc.storyList == null
          ? const Center(
              child: CircularProgressIndicator(color: Consts.inactiveColor))
          : userViewModelBloc.storyList!.isNotEmpty
              ? SizedBox(
                  height: size.height,
                  width: size.width,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            height: size.height / 12,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: userViewModelBloc.storyList!.length,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      userViewModelBloc.storyList!.length) {
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
                                    if (index == 0) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (userViewModelBloc
                                                .storyList![index]
                                                .storyDetailsList!
                                                .isNotEmpty) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (
                                                    context,
                                                  ) =>
                                                      StoryDetailPage(
                                                    currentStoryIndex:
                                                        userViewModelBloc
                                                                .storyList![0]
                                                                .storyDetailsList!
                                                                .isNotEmpty
                                                            ? index
                                                            : index - 1,
                                                    storyList: userViewModelBloc
                                                        .storyList!,
                                                  ),
                                                ),
                                              )
                                                  .then(
                                                (value) {
                                                  setState(() {});
                                                },
                                              );
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                radius: (size.height / 26) + 3,
                                                backgroundColor:
                                                    userViewModelBloc
                                                            .storyList![index]
                                                            .storyDetailsList!
                                                            .isNotEmpty
                                                        ? Consts
                                                            .tertiaryAppColor
                                                        : Colors.transparent,
                                                child: CircleAvatar(
                                                  radius: size.height / 26,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    userViewModelBloc
                                                        .user!.profilePhotoURL!,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    useRootNavigator: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        color: Consts
                                                            .backgroundColor,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            5,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              leading: const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .camera),
                                                              title: const Text(
                                                                  'Take a photo'),
                                                              splashColor: Colors
                                                                  .transparent,
                                                              onTap:
                                                                  pickImageFromCamera,
                                                            ),
                                                            ListTile(
                                                              leading: const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .image),
                                                              splashColor: Colors
                                                                  .transparent,
                                                              title: const Text(
                                                                  'Choose from gallery'),
                                                              onTap:
                                                                  pickImageFromGallery,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ).then(
                                                    (value) {
                                                      if (_newPickedImage !=
                                                          null) {
                                                        userViewModelBloc.add(
                                                          AddStoryEvent(
                                                            newStoryPhoto:
                                                                _newPickedImage!,
                                                            userID:
                                                                userViewModelBloc
                                                                    .storyList![
                                                                        index]
                                                                    .user
                                                                    .userID,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Consts.tertiaryAppColor,
                                                  child: FaIcon(
                                                    FontAwesomeIcons.plus,
                                                    color: Colors.black87,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StoryDetailPage(
                                                  currentStoryIndex:
                                                      userViewModelBloc
                                                              .storyList![0]
                                                              .storyDetailsList!
                                                              .isNotEmpty
                                                          ? index
                                                          : index - 1,
                                                  storyList: userViewModelBloc
                                                      .storyList!,
                                                ),
                                              ),
                                            )
                                                .then(
                                              (value) {
                                                setState(() {});
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: (size.height / 28) + 3,
                                            backgroundColor: userViewModelBloc
                                                    .storyList![index]
                                                    .listOfUsersHaveSeen!
                                                    .contains(userViewModelBloc
                                                        .user!.userID)
                                                ? Consts.inactiveColor
                                                : Consts.tertiaryAppColor,
                                            child: CircleAvatar(
                                              radius: size.height / 28,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                userViewModelBloc
                                                    .storyList![index]
                                                    .user
                                                    .profilePhotoURL!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                              children: getPostList(
                                  userViewModelBloc: userViewModelBloc)),
                          SizedBox(height: size.height / 10),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
    );
  }

  void setupScrollController() {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    _scrollController.addListener(
      () {
        if (_scrollController.positions.isNotEmpty) {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange) {
            getStories(userID: userViewModelBloc.storyList!.last.user.userID);
          }
        }
      },
    );
  }

  void getStories({String? userID, bool isInitFunction = false}) async {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(
      GetStoriesEvent(
        userID: userID ?? userViewModelBloc.user!.userID,
        countOfWillBeFetchedStoryCount: _countOfWillBeFetchedStoryCount,
        isInitFunction: isInitFunction,
      ),
    );
  }

  void pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _newPickedImage = pickedImage;
    });

    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newPickedImage = pickedImage;
    });

    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  List<Widget> getPostList({required UserViewModelBloc userViewModelBloc}) {
    List<Widget> postList = [];

    if (userViewModelBloc.storyList!.isNotEmpty) {
      for (int i = userViewModelBloc.storyList!.length - 1; i >= 0; i--) {
        if (userViewModelBloc.storyList![i].storyDetailsList!.isNotEmpty) {
          postList.add(
              StoryDetailCardWidget(story: userViewModelBloc.storyList![i]));
        }
      }
    }
    return postList;
  }
}
