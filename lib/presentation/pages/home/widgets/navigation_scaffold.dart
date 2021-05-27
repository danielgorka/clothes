import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/keys.dart';
import 'package:flutter/material.dart';

enum NavigationType {
  bottomNavBar,
  navRail,
  extendedNavRail,
}

class NavigationItem {
  final String label;
  final Widget icon;
  final PageRouteInfo route;
  final Widget? activeIcon;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    Widget? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

class NavigationScaffold extends StatelessWidget {
  final NavigationType navigationType;
  final List<NavigationItem> items;

  const NavigationScaffold({
    Key? key,
    this.navigationType = NavigationType.bottomNavBar,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: items.map((item) => item.route).toList(),
      builder: (context, child, animation) {
        final tabsRouter = context.tabsRouter;
        final showRail = navigationType == NavigationType.navRail ||
            navigationType == NavigationType.extendedNavRail;
        final extendedRail = navigationType == NavigationType.extendedNavRail;
        final showBottomNavBar = navigationType == NavigationType.bottomNavBar;

        Widget body = FadeTransition(
          key: Keys.navigationScaffoldBody,
          opacity: animation,
          child: child,
        );

        if (showRail) {
          body = _NavRail(
            tabsRouter: tabsRouter,
            items: items,
            extended: extendedRail,
            child: body,
          );
        }

        return Scaffold(
          key: Keys.navigationScaffold,
          body: body,
          bottomNavigationBar: showBottomNavBar
              ? _BottomNavBar(
                  tabsRouter: tabsRouter,
                  items: items,
                )
              : null,
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final TabsRouter tabsRouter;
  final List<NavigationItem> items;

  const _BottomNavBar({
    Key? key,
    required this.tabsRouter,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: items.map((item) {
        return BottomNavigationBarItem(
          activeIcon: item.activeIcon,
          icon: item.icon,
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _NavRail extends StatelessWidget {
  final TabsRouter tabsRouter;
  final List<NavigationItem> items;
  final bool extended;
  final Widget child;

  const _NavRail({
    Key? key,
    required this.tabsRouter,
    required this.items,
    this.extended = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          labelType: extended ? null : NavigationRailLabelType.all,
          extended: extended,
          selectedIndex: tabsRouter.activeIndex,
          destinations: items.map((item) {
            return NavigationRailDestination(
              icon: item.icon,
              selectedIcon: item.activeIcon,
              label: Text(item.label),
            );
          }).toList(),
          onDestinationSelected: tabsRouter.setActiveIndex,
        ),
        Expanded(child: child),
      ],
    );
  }
}
