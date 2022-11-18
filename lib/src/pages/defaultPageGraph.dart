import 'package:flutter/material.dart';
import 'package:routing_helper_services/src/pages/navigatorMiddleware.dart';
import 'dart:async';

import 'package:routing_helper_services/src/pages/pageGraph.dart';

class DefaultPageGraph implements PageGraph {
  @override
  Navigator? _navigator;

  @override
  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<bool> Function()? onBackButtonPressed;

  @override
  Map<String, PageRouteGenerator> pages = {};

  List<BottomNavigationBarItem> _bottomNavBarItems = [];
  List<String> _bottomNavRoutes = [];

  @override
  String? initialRoute;

  @override
  PageRouteGenerator? onGenerateRoute;

  int _currentBottomNavIndex = 0;

  @override
  NavigatorMiddleWare<Route> navigatorMiddleWare = NavigatorMiddleWare();

  void Function(int)? _onBottomNavItemClicked;

  set onBottomNavItemClicked(void Function(int) onBtmNavClicked) {
    _onBottomNavItemClicked = onBtmNavClicked;
  }

  @override
  BottomNavigationBar? get bottomNavigationBar {
    if (_bottomNavBarItems.length < 2) return null;
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      items: _bottomNavBarItems,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        navigatorKey?.currentState?.pushNamed(_bottomNavRoutes[index]);
        _currentBottomNavIndex = index;
        _onBottomNavItemClicked?.call(index);
      },
    );
  }

  Navigator get navigator {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      observers: [navigatorMiddleWare],
      onGenerateRoute: (settings) {
        MaterialPageRoute Function(RouteSettings) pageGenerator =
            pages[settings.name] as MaterialPageRoute Function(RouteSettings);
        return pageGenerator(settings);
      },
    );
  }

  set navigator(Navigator navigator) => _navigator = navigator;

  DefaultPageGraph({Future<bool> Function()? onBackButtonPressed}) {
    this.onBackButtonPressed = onBackButtonPressed ?? _popPageFromQueue;
  }

  @override
  addBottomNavigationBarItem(String pageName, Icon icon, {String label = ""}) {
    _bottomNavRoutes.add(pageName);
    _bottomNavBarItems.add(BottomNavigationBarItem(icon: icon, label: label));
  }

  ///
  /// Add page to the page graph
  ///
  @override
  addPageRoute(String name, PageRouteGenerator pageRouteGenerator,
      {Icon? icon, String label = ""}) {
    pages[name] = pageRouteGenerator;

    if (icon != null) addBottomNavigationBarItem(name, icon as Icon);
  }

  ///
  /// Pop a page from the navigator queue
  ///
  Future<bool> _popPageFromQueue() async {
    NavigatorState navigatorState =
        (navigatorKey?.currentState) as NavigatorState;

    // External navigator can be popped if this navigator cannot be popped
    if (!navigatorState.canPop()) return true;
    navigatorState.pop();
    return false;
  }

  ///
  /// Add a page to the page graph
  ///
  @override
  addPage(String name, Widget Function(BuildContext) pageGenerator,
      {Icon? icon, String label = ""}) {
    addPageRoute(
        name, (routeSettings) => MaterialPageRoute(builder: pageGenerator),
        icon: icon, label: label);
  }
}
