import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../consts/consts.dart';
import '../models/story_model.dart';

class StoryDetailCardWidget extends StatelessWidget {
  final StoryModel story;
  StoryDetailCardWidget({super.key, required this.story});
  final PageController _pageController = PageController(
    viewportFraction: 1, // Elemanların görünür genişliğini belirler.
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Consts.inactiveColor,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width,
          child: Text(
            story.user.userName!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: size.width,
          constraints: BoxConstraints(maxHeight: size.height / 2),
          color: Colors.black,
          child: PageView.builder(
            controller: _pageController,
            itemCount: story.storyDetailsList!.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Color(story.storyDetailsList![index]['dominantColor']),
                  // borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      story.storyDetailsList![index]['storyPhotoUrl'],
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Consts.inactiveColor,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.heart),
                  SizedBox(width: 15),
                  FaIcon(FontAwesomeIcons.comment),
                ],
              ),
              FaIcon(FontAwesomeIcons.share),
            ],
          ),
        ),
      ],
    );
  }
}
