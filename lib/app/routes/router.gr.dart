// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:clothes/presentation/pages/calendar_page.dart' as _i6;
import 'package:clothes/presentation/pages/clothes_page.dart' as _i4;
import 'package:clothes/presentation/pages/home/home_page.dart' as _i3;
import 'package:clothes/presentation/pages/outfits_page.dart' as _i5;
import 'package:flutter/material.dart' as _i2;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.HomePage();
        }),
    ClothesRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    OutfitsRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    CalendarRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    ClothesRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.ClothesPage();
        }),
    OutfitsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.OutfitsPage();
        }),
    CalendarRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.CalendarPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeRoute.name, path: '/', children: [
          _i1.RouteConfig(ClothesRouter.name, path: 'clothes', children: [
            _i1.RouteConfig(ClothesRoute.name, path: ''),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(OutfitsRouter.name, path: 'outfits', children: [
            _i1.RouteConfig(OutfitsRoute.name, path: ''),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(CalendarRouter.name, path: 'calendar', children: [
            _i1.RouteConfig(CalendarRoute.name, path: ''),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ])
        ]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

class ClothesRouter extends _i1.PageRouteInfo {
  const ClothesRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'clothes', initialChildren: children);

  static const String name = 'ClothesRouter';
}

class OutfitsRouter extends _i1.PageRouteInfo {
  const OutfitsRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'outfits', initialChildren: children);

  static const String name = 'OutfitsRouter';
}

class CalendarRouter extends _i1.PageRouteInfo {
  const CalendarRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'calendar', initialChildren: children);

  static const String name = 'CalendarRouter';
}

class ClothesRoute extends _i1.PageRouteInfo {
  const ClothesRoute() : super(name, path: '');

  static const String name = 'ClothesRoute';
}

class OutfitsRoute extends _i1.PageRouteInfo {
  const OutfitsRoute() : super(name, path: '');

  static const String name = 'OutfitsRoute';
}

class CalendarRoute extends _i1.PageRouteInfo {
  const CalendarRoute() : super(name, path: '');

  static const String name = 'CalendarRoute';
}