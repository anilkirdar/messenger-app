import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../consts/consts.dart';
import '../../pages/tab_pages/tab_items.dart';
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
    Size size = MediaQuery.of(context).size;

    return CupertinoTabScaffold(
      backgroundColor: Consts.backgroundColor,
      tabBar: CustomTabBar(
        // backgroundColor: Consts.backgroundColor,
        height: size.height / 10,
        onTap: (index) {
          onSelectedTab(TabItem.values[index]);
        },
        items: [
          createNavItem(tabItem: TabItem.directory),
          createNavItem(
            tabItem: TabItem.chats,
            // inactiveColor: Colors.black87.withAlpha((255 * 0.8).toInt()),
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
      Color activeColor = Consts.primaryAppColor}) {
    final TabItemData currentTab = TabItemData.allTabs[tabItem]!;

    return BottomNavigationBarItem(
      label: currentTab.title,
      icon: FaIcon(
        currentTab.inactiveIcon,
        color: inactiveColor,
        size: 32,
      ),
      activeIcon: FaIcon(
        currentTab.activeIcon,
        color: activeColor,
        size: 32,
      ),
    );
  }
}
