import 'package:flutter/material.dart';
import 'package:routing_helper_services/src/nav_widgets/nav_bar_item.dart';

class NavBar extends StatelessWidget {
  final Set<NavBarItem> icons;

  const NavBar({required this.icons, Key? key}) : super(key: key);

  Widget generateIcon(NavBarItem item) {
    return InkWell(onTap: item.onClick, child: item.icon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: icons.map(generateIcon).toList()));
  }
}
