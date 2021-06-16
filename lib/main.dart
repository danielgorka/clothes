import 'package:clothes/app/app.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';

import 'app/configure/configure_nonweb.dart'
    if (dart.library.html) 'app/configure/configure_web.dart';

Future<void> main() async {
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(App());
}
