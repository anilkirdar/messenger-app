import 'package:flutter/material.dart';

class StoryDetailPage extends StatelessWidget {
  const StoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: size.height,
                  width: size.width / 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
