import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import 'tab_pages/tab_items.dart';
import '../widgets/bottomNavBar/custom_bottom_nav_bar.dart';
import 'tab_pages/chats_page.dart';
import 'tab_pages/directory_page.dart';
import 'tab_pages/profile_settings_page.dart';

class TabsBasePage extends StatefulWidget {
  final UserModel user;

  const TabsBasePage({super.key, required this.user});

  @override
  State<TabsBasePage> createState() => _TabsBasePageState();
}

class _TabsBasePageState extends State<TabsBasePage> {
  late TabItem _currentTab;

  Map<TabItem, Widget> _allPages() {
    return {
      TabItem.directory: const DirectoryPage(),
      TabItem.chats: const ChatsPage(),
      TabItem.profile: ProfileSettingsPage(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.directory: GlobalKey<NavigatorState>(),
    TabItem.chats: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _currentTab = TabItem.chats;
    NotificationService.initializeFCMNotification();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CustomBottomNavBar(
        currentTab: _currentTab,
        pageCreator: _allPages(),
        navigatorKeys: navigatorKeys,
        onSelectedTab: (tabItem) {
          if (tabItem == _currentTab) {
            navigatorKeys[tabItem]!.currentState!.popUntil(
                  (route) => route.isFirst,
                );
          } else {
            setState(() {
              _currentTab = tabItem;
            });
          }
        },
      ),
    );
  }
}
