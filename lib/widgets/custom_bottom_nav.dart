import 'package:flutter/cupertino.dart';
import '../tab_items.dart';

// ignore: must_be_immutable
class CustomBottomNav extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomNav(
      {super.key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.pageCreator,
      required this.navigatorKeys});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (index) {
          onSelectedTab(TabItem.values[index]);
        },
        items: [
          createNavItem(TabItem.users),
          createNavItem(TabItem.profile),
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

  BottomNavigationBarItem createNavItem(TabItem tabItem) {
    final TabItemData currentTab = TabItemData.allTabs[tabItem]!;

    return BottomNavigationBarItem(
      label: currentTab.title,
      icon: Icon(currentTab.icon),
    );
  }
}
