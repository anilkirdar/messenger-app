import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { messages, home, profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.messages:
        TabItemData(title: 'Messages', icon: FontAwesomeIcons.solidMessage),
    TabItem.home: TabItemData(title: 'Home', icon: FontAwesomeIcons.house),
    TabItem.profile:
        TabItemData(title: 'Profile', icon: FontAwesomeIcons.solidUser),
  };
}
