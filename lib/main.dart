import 'package:clothes/app/app.dart';
import 'package:clothes/app/app_bloc_observer.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/configure/configure_nonweb.dart'
    if (dart.library.html) 'app/configure/configure_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(App());
}
