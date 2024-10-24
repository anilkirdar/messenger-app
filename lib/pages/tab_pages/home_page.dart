import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/user_view_model_bloc.dart';
import '../../consts/consts.dart';

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chatrix',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: userViewModelBloc.storyList == null
            ? const Center(child: CircularProgressIndicator())
            : userViewModelBloc.storyList!.isNotEmpty
                ? SizedBox(
                    height: size.height,
                    width: size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: size.width,
                              height: size.height / 12,
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
                                            color: Colors.black54,
                                          ),
                                        ),
                                      );
                                    } else {
                                      _hasMore = false;
                                      return null;
                                    }
                                  } else {
                                    if (index == 0) {
                                      if (userViewModelBloc.storyList![0]
                                          .storyPhotoUrlList!.isNotEmpty) {}
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                radius: (size.height / 26) + 3,
                                                backgroundColor:
                                                    userViewModelBloc
                                                            .storyList![0]
                                                            .storyPhotoUrlList!
                                                            .isNotEmpty
                                                        ? Consts
                                                            .tertiaryAppColor
                                                        : Colors.transparent,
                                                child: CircleAvatar(
                                                  radius: size.height / 26,
                                                  backgroundImage: NetworkImage(
                                                    userViewModelBloc
                                                        .user!.profilePhotoURL!,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return SizedBox(
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
                                                              onTap:
                                                                  pickImageFromCamera,
                                                            ),
                                                            ListTile(
                                                              leading: const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .image),
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
                                                            storyPhotoUrl:
                                                                _newPickedImage!
                                                                    .path,
                                                            userID:
                                                                userViewModelBloc
                                                                    .storyList![
                                                                        index]
                                                                    .userID,
                                                            resultCallBack:
                                                                (result) {
                                                              if (result) {
                                                                userViewModelBloc
                                                                    .storyList![
                                                                        index]
                                                                    .storyPhotoUrlList!
                                                                    .add(_newPickedImage!
                                                                        .path);
                                                              }
                                                            },
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
                                          onTap: () {},
                                          child: CircleAvatar(
                                            radius: (size.height / 28) + 3,
                                            backgroundColor:
                                                Consts.tertiaryAppColor,
                                            child: CircleAvatar(
                                              radius: size.height / 28,
                                              backgroundImage: NetworkImage(
                                                userViewModelBloc
                                                    .storyList![index]
                                                    .profilePhotoURL,
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
                        ],
                      ),
                    ),
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

      // body: SizedBox(
      //   height: size.height,
      //   width: size.width,
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.vertical,
      //     child: Column(
      //       children: [
      //         SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: Row(
      //             children: [
      //               CircleAvatar(
      //                 backgroundImage: NetworkImage(
      //                   userViewModelBloc.user!.profilePhotoURL!,
      //                 ),
      //               ),
      //               Container(
      //                 color: Colors.blue,
      //                 width: size.width,
      //                 height: 30,
      //               ),
      //               Container(
      //                 color: Colors.red,
      //                 width: size.width,
      //                 height: 30,
      //               ),
      //               Container(
      //                 color: Colors.green,
      //                 width: size.width,
      //                 height: 30,
      //               ),
      //             ],
      //           ),
      //         ),
      //         Container(
      //           color: Colors.yellow,
      //           width: size.width,
      //           height: 30,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  void initStateMethods() {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    getStories();
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          getStories(userID: userViewModelBloc.storyList!.last.userID);
        }
      },
    );
  }

  void getStories({String? userID}) async {
    UserViewModelBloc userViewModelBloc = context.read<UserViewModelBloc>();

    userViewModelBloc.add(
      GetStoriesEvent(
        userID: userID ?? userViewModelBloc.user!.userID,
        countOfWillBeFetchedStoryCount: _countOfWillBeFetchedStoryCount,
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
      Navigator.pop(context);
    }
  }

  void pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newPickedImage = pickedImage;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
