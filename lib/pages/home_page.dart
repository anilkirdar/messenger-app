import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../tab_items.dart';
import '../widgets/custom_bottom_nav.dart';
import 'tab_pages/messages_page.dart';
import 'tab_pages/profile_page.dart';
import 'tab_pages/users_page.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TabItem _currentTab;
  Map<TabItem, Widget> _allPages() {
    return {
      TabItem.users: const UsersPage(),
      TabItem.messages: const MessagesPage(),
      TabItem.profile: const ProfilePage(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.messages: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    _currentTab = TabItem.users;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CustomBottomNav(
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
