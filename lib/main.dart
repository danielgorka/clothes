import 'package:clothes/app/app.dart';
import 'package:flutter/material.dart';

import 'app/configure/configure_nonweb.dart'
    if (dart.library.html) 'app/configure/configure_web.dart';

void main() {
  configureApp();
  runApp(App());
}
