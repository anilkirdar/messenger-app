import 'package:flutter/material.dart';

import '../models/story_model.dart';

class StoryDetailCardWidget extends StatelessWidget {
  final StoryModel story;
  const StoryDetailCardWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    
    return SizedBox();

    // return Container(
    //   width: size.width,
    //   constraints: BoxConstraints(maxHeight: size.height / 2),
    //   child: SliverGrid(
    //     gridDelegate:
    //         const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    //     delegate: SliverChildBuilderDelegate(
    //       (context, index) {
    //         return Image.network(
    //           story.storyDetailsList![index]['storyPhotoUrl'],
    //           fit: BoxFit.contain,
    //         );
    //       },
    //       childCount: story.storyDetailsList!.length - 1,
    //     ),
    //   ),
    // );
  }
}
