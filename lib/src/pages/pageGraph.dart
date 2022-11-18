import 'dart:async';

import 'package:flutter/material.dart';
import 'package:routing_helper_services/src/pages/navigatorMiddleware.dart';

typedef PageRouteGenerator = MaterialPageRoute Function(RouteSettings);

abstract class PageGraph {
  set pages(Map<String, MaterialPageRoute Function(RouteSettings)> pages);
  Map<String, MaterialPageRoute Function(RouteSettings)> get pages;

  set onBackButtonPressed(Future<bool> Function()? onBackButtonPressed);
  Future<bool> Function()? get onBackButtonPressed;

  set navigator(Navigator navigator);
  Navigator get navigator;

  BottomNavigationBar? get bottomNavigationBar;

  set navigatorKey(GlobalKey<NavigatorState>? navigatorKey);
  GlobalKey<NavigatorState>? get navigatorKey;

  set initialRoute(String? initialRoute);
  String? get initialRoute;

  set onGenerateRoute(PageRouteGenerator? onGenerateRoute);
  PageRouteGenerator? get onGenerateRoute;

  NavigatorMiddleWare get navigatorMiddleWare;

  addPageRoute(String name, PageRouteGenerator pageRouteGenerator,
      {Icon icon, String label = ""});
  addPage(String name, Widget Function(BuildContext) pageGenerator,
      {Icon icon, String label = ""});

  addBottomNavigationBarItem(String pageName, Icon icon, {String label = ""});
}
