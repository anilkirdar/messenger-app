import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user_model.dart';
import '../profile_settings_page.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.userName!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(
                  builder: (context) => ProfileSettingsPage(),
                ));
              },
              icon: FaIcon(FontAwesomeIcons.gripLines),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  createBasicColumn(
                      size: size,
                      text: 'Name',
                      subText: 'Biography',
                      isFirstColumn: true),
                  createBasicColumn(size: size, text: '0', subText: 'posts'),
                  createBasicColumn(
                      size: size, text: '72', subText: 'followers'),
                  createBasicColumn(
                      size: size, text: '119', subText: 'following'),
                ],
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black26,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Empty label',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black26,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Empty label',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.black26,
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: FaIcon(
                        FontAwesomeIcons.userPlus,
                        color: Colors.black87,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                createIconColumn(
                    iconData: FontAwesomeIcons.tableCellsLarge, isActive: true),
                createIconColumn(iconData: FontAwesomeIcons.clapperboard),
                createIconColumn(iconData: FontAwesomeIcons.user),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Text(
                'No capture found!',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createBasicColumn({
    bool isFirstColumn = false,
    required Size size,
    required String text,
    required String subText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isFirstColumn)
          Column(
            children: [
              CircleAvatar(
                radius: size.width / 10,
                backgroundImage: NetworkImage(user.profilePhotoURL!),
              ),
              SizedBox(height: 5),
            ],
          ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget createIconColumn({required IconData iconData, bool isActive = false}) {
    return Expanded(
      child: Column(
        children: [
          FaIcon(
            iconData,
            color: isActive ? Colors.black87 : Colors.black54,
          ),
          Divider(color: isActive ? Colors.black87 : null),
        ],
      ),
    );
  }
}
