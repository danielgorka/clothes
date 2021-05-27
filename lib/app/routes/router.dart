import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:clothes/presentation/pages/calendar_page.dart';
import 'package:clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/presentation/pages/home/home_page.dart';
import 'package:clothes/presentation/pages/outfits_page.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: HomePage,
      initial: true,
      children: [
        AutoRoute(
          path: 'clothes',
          name: 'ClothesRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: ClothesPage,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'outfits',
          name: 'OutfitsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: OutfitsPage,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'calendar',
          name: 'CalendarRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: CalendarPage,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
      ],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
