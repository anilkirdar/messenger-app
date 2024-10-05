import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { users, messages, profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData(title: 'Users', icon: FontAwesomeIcons.users),
    TabItem.messages:
        TabItemData(title: 'Messages', icon: FontAwesomeIcons.solidMessage),
    TabItem.profile:
        TabItemData(title: 'Profile', icon: FontAwesomeIcons.solidUser),
  };
}
