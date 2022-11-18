import 'package:flutter/material.dart';

class NavBarItem {
  String name;
  Widget icon;
  Function() onClick;

  NavBarItem(this.name, this.icon, this.onClick);

  @override
  int get hashCode => Object.hash(name, null);

  bool operator ==(dynamic other) =>
      other is NavBarItem && other.hashCode == hashCode;
}
