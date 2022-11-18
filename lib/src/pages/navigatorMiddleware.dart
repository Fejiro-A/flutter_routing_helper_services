import 'package:flutter/material.dart';

typedef OnRouteChanged<R extends Route> = void Function(
    R? route, R? previousRoute);

/// Navigator middleware that can be added to a navigator to intercept routing
/// commands and perform additional actions based on what those commands are
/// Interceptable commands (named or otherwise):
///    - push
///    - pop
///    - remove
///    - replace
///    - userGestureStarted
///    - userGestureStopped
class NavigatorMiddleWare<R extends Route> extends RouteObserver<R> {
  final List<R> _stack = [];
  OnRouteChanged? onPush;
  OnRouteChanged? onPop;
  OnRouteChanged? onRemove;
  OnRouteChanged? onReplace;
  OnRouteChanged? onStartUserGesture;
  OnRouteChanged? onStopUserGesture;

  NavigatorMiddleWare(
      {this.onPush,
      this.onPop,
      this.onRemove,
      this.onReplace,
      this.onStartUserGesture,
      this.onStopUserGesture});

  List<R> get stack => List.unmodifiable(_stack);

  @override
  void didPop(Route route, Route? previousRoute) {
    int lastIndex = _stack.lastIndexOf(route as R);
    if (lastIndex >= 0) {
      _stack.removeAt(lastIndex);
      onPop?.call(route, previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _stack.add(route as R);
    onPush?.call(route, previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _stack.remove(route);
    onRemove?.call(route, previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute == null) {
      super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
      return;
    }
    int lastIndex = _stack.lastIndexOf(oldRoute as R);
    if (lastIndex >= 0) {
      if (newRoute != null) {
        // Actually replace old route
        _stack[lastIndex] = newRoute as R;
      } else {
        // remove old route
        _stack.removeAt(lastIndex);
      }
      onReplace?.call(newRoute, oldRoute);
    }

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    onStartUserGesture?.call(route, previousRoute);
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    onStopUserGesture?.call(null, null);
    super.didStopUserGesture();
  }
}
