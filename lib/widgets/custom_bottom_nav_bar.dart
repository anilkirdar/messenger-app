import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../consts/consts.dart';
import '../tab_items.dart';
import 'custom_tab_bar.dart';

// ignore: must_be_immutable
class CustomBottomNavBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomNavBar(
      {super.key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.pageCreator,
      required this.navigatorKeys});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.transparent,
      tabBar: CustomTabBar(
        // backgroundColor: Colors.white,
        height: MediaQuery.of(context).size.height / 12,
        onTap: (index) {
          onSelectedTab(TabItem.values[index]);
        },
        items: [
          createNavItem(tabItem: TabItem.messages),
          createNavItem(
            tabItem: TabItem.home,
            inactiveColor: Colors.black87.withAlpha((255*0.8).toInt()),
          ),
          createNavItem(tabItem: TabItem.profile),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          navigatorKey: navigatorKeys[TabItem.values[index]],
          builder: (context) {
            return pageCreator[currentTab]!;
          },
        );
      },
    );
  }

  BottomNavigationBarItem createNavItem(
      {required TabItem tabItem,
      Color inactiveColor = CupertinoColors.inactiveGray,
      Color activeColor = Consts.tertiaryAppColor}) {
    final TabItemData currentTab = TabItemData.allTabs[tabItem]!;

    return BottomNavigationBarItem(
      label: currentTab.title,
      icon: FaIcon(currentTab.icon, color: inactiveColor),
      activeIcon: FaIcon(currentTab.icon, color: activeColor),
    );
  }
}
