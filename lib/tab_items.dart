import 'package:flutter/material.dart';

enum TabItem { users, profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData(title: 'Users', icon: Icons.person),
    TabItem.profile:
        TabItemData(title: 'Profile', icon: Icons.supervised_user_circle),
  };
}
