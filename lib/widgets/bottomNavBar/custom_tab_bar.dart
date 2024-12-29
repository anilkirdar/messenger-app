import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/consts.dart';

// ignore: must_be_immutable
class CustomTabBar extends StatelessWidget implements CupertinoTabBar {
  @override
  final List<BottomNavigationBarItem> items;
  @override
  final ValueChanged<int>? onTap;
  @override
  int currentIndex;
  @override
  final Color? backgroundColor;
  @override
  final Color? activeColor;
  @override
  final Color inactiveColor;
  @override
  final double iconSize;
  @override
  final double height;
  @override
  final Border? border;
  @override
  Size get preferredSize => Size.fromHeight(height);

  CustomTabBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 1,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor = CupertinoColors.inactiveGray,
    this.iconSize = 25.0,
    this.height = 50.0,
    this.border = const Border(
      top: BorderSide(
        color: CupertinoDynamicColor.withBrightness(
          color: Color(0x4D000000),
          darkColor: Color(0x29000000),
        ),
        width: 0.0, // 0.0 means one physical pixel
      ),
    ),
  });

  @override
  Widget build(BuildContext context) {
    // final int centerIndex = ((items.length - 1) / 2).round();
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: height,
      child: SizedBox(
        width: size.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildTabItems(),
        ),
      ),
    );

    // return SizedBox(
    //   height: height,
    //   child: Stack(
    //     children: [
    //       CustomPaint(
    //         size: Size(size.width, size.height / 12),
    //         painter: BottomNavBarCustomPainter(),
    //       ),
    //       Center(
    //         heightFactor: 0.6,
    //         child: CircleAvatar(
    //           radius: 28,
    //           backgroundColor: Consts.primaryAppColor,
    //           child: _buildSingleTabItem(
    //             item: items[centerIndex],
    //             index: centerIndex,
    //             active: false,
    //             // active: currentIndex == centerIndex,
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         width: size.width,
    //         height: 80,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: _buildTabItems(centerIndex: centerIndex),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  List<Widget> _buildTabItems() {
    List<Widget> list = [];
    for (var index = 0; index < items.length; index++) {
      final bool active = index == currentIndex;
      list.add(_buildSingleTabItem(
          item: items[index], index: index, active: active));
      // if (centerIndex == index) {
      //   list.add(SizedBox());
      // } else {
      //   list.add(_buildSingleTabItem(
      //       item: items[index], index: index, active: active));
      // }
    }
    return list;
  }

  Widget _buildSingleTabItem(
      {required BottomNavigationBarItem item,
      required int index,
      required bool active}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          onPressed: () {
            onTap!(index);
            if (currentIndex != index) {
              currentIndex = index;
            }
          },
          icon: active ? item.activeIcon : item.icon,
          iconSize: iconSize,
        ),
        Text(
          item.label!,
          style: GoogleFonts.poppins(
            color: active ? Consts.primaryAppColor : Consts.inactiveColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  bool opaque(BuildContext context) {
    final Color backgroundColor =
        this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;
    return CupertinoDynamicColor.resolve(backgroundColor, context).a == 0xFF;
  }

  @override
  CustomTabBar copyWith({
    Key? key,
    List<BottomNavigationBarItem>? items,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    double? height,
    Border? border,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      height: height ?? this.height,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
    );
  }
}

class BottomNavBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20)
      ..arcToPoint(
        Offset(size.width * 0.60, 20),
        radius: Radius.circular(10),
        clockwise: false,
      )
      ..quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0)
      ..quadraticBezierTo(size.width * 0.80, 0, size.width, 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
