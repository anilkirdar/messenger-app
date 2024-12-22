import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../tab_items.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'chat_page.dart';
import 'messages_page.dart';
import 'tab_pages/home_page.dart';
import 'tab_pages/profile_page.dart';

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
      TabItem.messages: const MessagesPage(),
      TabItem.home: const HomePage(),
      TabItem.profile: ProfilePage(user: widget.user),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.messages: GlobalKey<NavigatorState>(),
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  late FirebaseMessaging _firebaseNotification;
  late NotificationSettings _notificationSettings;
  RemoteMessage? _initialNotification;

  @override
  void initState() {
    super.initState();
    _initStateMethods();
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

  void _initStateMethods() async {
    _currentTab = TabItem.home;
    _firebaseNotification = FirebaseMessaging.instance;
    _notificationSettings = await _firebaseNotification.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    _initialNotification = await _firebaseNotification.getInitialMessage();
    if (_initialNotification != null) {
      _handleMessage(_initialNotification!);
    }
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          currentUser: UserModel.fromMap(message.data['currentUser']),
          otherUser: UserModel.fromMap(message.data['otherUser']),
        ),
      ),
    );
  }
}
