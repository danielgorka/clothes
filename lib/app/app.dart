import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:clothes/app/theme.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routeInformationParser: _router.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate(_router),
    );
  }
}
