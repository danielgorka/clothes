import 'package:intl/intl_standalone.dart';

Future<void> configureApp() async {
  await findSystemLocale();
}
