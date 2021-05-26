import 'package:auto_route/annotations.dart';
import 'package:clothes/presentation/pages/home_page.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: HomePage,
      initial: true,
      children: [],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
