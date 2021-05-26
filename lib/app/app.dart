import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clothes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate(_router),
    );
  }
}
