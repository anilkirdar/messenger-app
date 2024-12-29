import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { directory, chats, profile }

class TabItemData {
  final String title;
  final IconData inactiveIcon;
  final IconData activeIcon;

  TabItemData(
      {required this.title,
      required this.inactiveIcon,
      required this.activeIcon});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.directory: TabItemData(
        title: 'Directory',
        inactiveIcon: FontAwesomeIcons.users,
        activeIcon: FontAwesomeIcons.users),
    TabItem.chats: TabItemData(
        title: 'Chats',
        inactiveIcon: FontAwesomeIcons.message,
        activeIcon: FontAwesomeIcons.solidMessage),
    TabItem.profile: TabItemData(
        title: 'Profile',
        inactiveIcon: FontAwesomeIcons.gear,
        activeIcon: FontAwesomeIcons.gear),
  };
}
