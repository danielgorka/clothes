import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:clothes/app/pages/home_page.dart';
import 'package:clothes/features/calendar/presentation/pages/calendar_page.dart';
import 'package:clothes/features/clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/features/clothes/presentation/pages/edit_cloth_page.dart';
import 'package:clothes/features/clothes/presentation/pages/edit_image_page.dart';
import 'package:clothes/features/outfits/presentation/pages/outfits_page.dart';

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
            AutoRoute(
              path: ':clothId',
              page: EditClothPage,
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
    AutoRoute<Uint8List>(
      path: 'edit-image',
      page: EditImagePage,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
