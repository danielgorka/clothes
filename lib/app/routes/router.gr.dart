// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'dart:typed_data' as _i4;

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:clothes/app/pages/home_page.dart' as _i3;
import 'package:clothes/features/calendar/presentation/pages/calendar_page.dart'
    as _i8;
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    as _i9;
import 'package:clothes/features/clothes/presentation/pages/clothes_page.dart'
    as _i6;
import 'package:clothes/features/clothes/presentation/pages/edit_image_page.dart'
    as _i5;
import 'package:clothes/features/outfits/presentation/pages/outfits_page.dart'
    as _i7;
import 'package:flutter/material.dart' as _i2;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
          return _i3.HomePage(
              key: args.key,
              clothesRouter: args.clothesRouter,
              outfitsRouter: args.outfitsRouter,
              calendarRouter: args.calendarRouter);
        }),
    EditImageRoute.name: (routeData) => _i1.MaterialPageX<_i4.Uint8List>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<EditImageRouteArgs>();
          return _i5.EditImagePage(key: args.key, source: args.source);
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
          return const _i6.ClothesPage();
        }),
    OutfitsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i7.OutfitsPage();
        }),
    CalendarRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i8.CalendarPage();
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
        _i1.RouteConfig(EditImageRoute.name, path: 'edit-image'),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class HomeRoute extends _i1.PageRouteInfo<HomeRouteArgs> {
  HomeRoute(
      {_i2.Key? key,
      _i1.PageRouteInfo<dynamic>? clothesRouter,
      _i1.PageRouteInfo<dynamic>? outfitsRouter,
      _i1.PageRouteInfo<dynamic>? calendarRouter,
      List<_i1.PageRouteInfo>? children})
      : super(name,
            path: '/',
            args: HomeRouteArgs(
                key: key,
                clothesRouter: clothesRouter,
                outfitsRouter: outfitsRouter,
                calendarRouter: calendarRouter),
            initialChildren: children);

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs(
      {this.key, this.clothesRouter, this.outfitsRouter, this.calendarRouter});

  final _i2.Key? key;

  final _i1.PageRouteInfo<dynamic>? clothesRouter;

  final _i1.PageRouteInfo<dynamic>? outfitsRouter;

  final _i1.PageRouteInfo<dynamic>? calendarRouter;
}

class EditImageRoute extends _i1.PageRouteInfo<EditImageRouteArgs> {
  EditImageRoute({_i2.Key? key, required _i9.ImagePickerSource source})
      : super(name,
            path: 'edit-image',
            args: EditImageRouteArgs(key: key, source: source));

  static const String name = 'EditImageRoute';
}

class EditImageRouteArgs {
  const EditImageRouteArgs({this.key, required this.source});

  final _i2.Key? key;

  final _i9.ImagePickerSource source;
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
