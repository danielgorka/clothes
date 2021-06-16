import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/route/route_data_scope.dart';
import 'package:clothes/app/pages/home_page.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_wrapper.dart';
import '../../helpers/display_size.dart';

typedef ThemeColorGetter = Color? Function(Theme theme);

class MockAppRouter extends RootStackRouter {
  static const main = 'main';
  static const tab1 = '1';
  static const tab2 = '2';
  static const tab3 = '3';
  static const tabText1 = 'Tab 1';
  static const tabText2 = 'Tab 2';
  static const tabText3 = 'Tab 3';

  MockAppRouter() : super(null);

  @override
  final Map<String, PageFactory> pagesMap = {
    main: (routeData) => MaterialPageX<dynamic>(
          routeData: routeData,
          builder: (_) {
            return Container();
          },
        ),
    tab1: (routeData) => MaterialPageX<dynamic>(
          routeData: routeData,
          builder: (_) {
            return const Text(tabText1);
          },
        ),
    tab2: (routeData) => MaterialPageX<dynamic>(
          routeData: routeData,
          builder: (_) {
            return const Text(tabText2);
          },
        ),
    tab3: (routeData) => MaterialPageX<dynamic>(
          routeData: routeData,
          builder: (_) {
            return const Text(tabText3);
          },
        ),
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(main, path: '/', children: [
          RouteConfig(tab1, path: tab1, children: [
            RouteConfig(tab1, path: ''),
          ]),
          RouteConfig(tab2, path: tab2, children: [
            RouteConfig(tab2, path: ''),
          ]),
          RouteConfig(tab3, path: tab3, children: [
            RouteConfig(tab3, path: ''),
          ])
        ]),
      ];
}

void main() {
  final baseWidget = wrapWithApp(
    RouteDataScope(
      routeData: RouteData(
        route: const RouteMatch(
          routeName: MockAppRouter.main,
          segments: [],
          path: '/',
          stringMatch: '/',
          key: ValueKey(MockAppRouter.main),
        ),
        router: MockAppRouter(),
      ),
      segmentsHash: 0,
      child: RouterScope(
        segmentsHash: 0,
        inheritableObserversBuilder: () => [],
        controller: MockAppRouter(),
        navigatorObservers: const [],
        child: Builder(builder: (context) {
          return const HomePage(
            clothesRouter: PageRouteInfo(
              MockAppRouter.tab1,
              path: MockAppRouter.tab1,
            ),
            outfitsRouter: PageRouteInfo(
              MockAppRouter.tab2,
              path: MockAppRouter.tab2,
            ),
            calendarRouter: PageRouteInfo(
              MockAppRouter.tab3,
              path: MockAppRouter.tab3,
            ),
          );
        }),
      ),
    ),
  );

  group(
    'NavigationScaffold',
    () {
      Future<void> shouldDisplayThreeItems(WidgetTester tester) async {
        // arrange
        await tester.pumpWidget(baseWidget);
        await tester.pump();
        // assert
        expect(find.byKey(Keys.clothesNavbarIcon), findsOneWidget);
        expect(find.byKey(Keys.outfitsNavbarIcon), findsOneWidget);
        expect(find.byKey(Keys.calendarNavbarIcon), findsOneWidget);
      }

      Future<void> shouldDisplayPage(
          WidgetTester tester, String text, Key tapKey) async {
        // arrange
        await tester.pumpWidget(baseWidget);
        await tester.pump();
        // act
        await tester.tap(find.byKey(tapKey));
        await tester.pumpAndSettle();
        // assert
        expect(find.text(text), findsOneWidget);
      }

      Future<void> shouldDisplayClothesPage(WidgetTester tester) async {
        shouldDisplayPage(
          tester,
          MockAppRouter.tabText1,
          Keys.clothesNavbarIcon,
        );
      }

      Future<void> shouldDisplayOutfitsPage(WidgetTester tester) async {
        shouldDisplayPage(
          tester,
          MockAppRouter.tabText2,
          Keys.outfitsNavbarIcon,
        );
      }

      Future<void> shouldDisplayCalendarPage(WidgetTester tester) async {
        shouldDisplayPage(
          tester,
          MockAppRouter.tabText3,
          Keys.calendarNavbarIcon,
        );
      }

      Future<void> shouldChangeItemsColor(
        WidgetTester tester, {
        required ThemeColorGetter unselectedColor,
        required ThemeColorGetter selectedColor,
      }) async {
        // arrange
        await tester.pumpWidget(baseWidget);
        await tester.pump();
        // act
        await tester.tap(find.byKey(Keys.calendarNavbarIcon));
        await tester.pumpAndSettle();
        // assert
        final theme = tester.widget<Theme>(find.byType(Theme));

        final clothesIcon = tester.element(find.byKey(Keys.clothesNavbarIcon));
        final clothesIconTheme =
            clothesIcon.findAncestorWidgetOfExactType<IconTheme>()!;
        final unselected = unselectedColor(theme);
        expect(
          clothesIconTheme.data.color?.value,
          equals(unselected?.value),
        );

        final calendarIcon =
            tester.element(find.byKey(Keys.calendarNavbarIcon));
        final calendarIconTheme =
            calendarIcon.findAncestorWidgetOfExactType<IconTheme>()!;
        final selected = selectedColor(theme);
        expect(
          calendarIconTheme.data.color?.value,
          equals(selected?.value),
        );
      }

      group(
        'Small display',
        () {
          testWidgets(
            'should display BottomNavigationBar when display is small',
            (tester) async {
              // arrange
              tester.setSmallDisplaySize();
              await tester.pumpWidget(baseWidget);
              await tester.pump();
              // assert
              expect(find.byType(NavigationRail), findsNothing);
              expect(find.byType(BottomNavigationBar), findsOneWidget);
            },
          );
          testWidgets(
            'should display navigation bar or rail with '
            '3 items (clothes, outfits, calendar)',
            (tester) async {
              tester.setSmallDisplaySize();
              await shouldDisplayThreeItems(tester);
            },
          );

          testWidgets(
            'should display ClothesPage on clothes item click',
            (tester) async {
              tester.setSmallDisplaySize();
              await shouldDisplayClothesPage(tester);
            },
          );
          testWidgets(
            'should display OutfitsPage on outfit item click',
            (tester) async {
              tester.setSmallDisplaySize();
              await shouldDisplayOutfitsPage(tester);
            },
          );
          testWidgets(
            'should display CalendarPage on calendar item click',
            (tester) async {
              tester.setSmallDisplaySize();
              await shouldDisplayCalendarPage(tester);
            },
          );
          testWidgets(
            'should change color of the last selected '
            'and currently selected item',
            (tester) async {
              tester.setSmallDisplaySize();
              await shouldChangeItemsColor(
                tester,
                unselectedColor: (theme) =>
                    theme.data.bottomNavigationBarTheme.unselectedIconTheme
                        ?.color ??
                    theme.data.unselectedWidgetColor,
                selectedColor: (theme) =>
                    theme.data.bottomNavigationBarTheme.selectedIconTheme
                        ?.color ??
                    theme.data.primaryColor,
              );
            },
          );
        },
      );

      group(
        'Medium display',
        () {
          testWidgets(
            'should display not extended NavigationRail when display is medium',
            (tester) async {
              // arrange
              tester.setMediumDisplaySize();
              await tester.pumpWidget(baseWidget);
              await tester.pump();
              // assert
              expect(find.byType(BottomNavigationBar), findsNothing);
              final finder = find.byType(NavigationRail);
              expect(finder, findsOneWidget);
              final navRail = tester.widget<NavigationRail>(finder);
              expect(navRail.extended, equals(false));
            },
          );
          testWidgets(
            'should display navigation bar or rail with '
            '3 items (clothes, outfits, calendar)',
            (tester) async {
              tester.setMediumDisplaySize();
              await shouldDisplayThreeItems(tester);
            },
          );

          testWidgets(
            'should display ClothesPage on clothes item click',
            (tester) async {
              tester.setMediumDisplaySize();
              await shouldDisplayClothesPage(tester);
            },
          );
          testWidgets(
            'should display OutfitsPage on outfit item click',
            (tester) async {
              tester.setMediumDisplaySize();
              await shouldDisplayOutfitsPage(tester);
            },
          );
          testWidgets(
            'should display CalendarPage on calendar item click',
            (tester) async {
              tester.setMediumDisplaySize();
              await shouldDisplayCalendarPage(tester);
            },
          );
          testWidgets(
            'should change color of the last selected '
            'and currently selected item',
            (tester) async {
              tester.setMediumDisplaySize();
              await shouldChangeItemsColor(
                tester,
                unselectedColor: (theme) =>
                    theme.data.navigationRailTheme.unselectedIconTheme?.color ??
                    theme.data.colorScheme.onSurface,
                selectedColor: (theme) =>
                    theme.data.navigationRailTheme.selectedIconTheme?.color ??
                    theme.data.colorScheme.primary,
              );
            },
          );
        },
      );

      group(
        'Large display',
        () {
          testWidgets(
            'should display extended NavigationRail when display is large',
            (tester) async {
              // arrange
              tester.setLargeDisplaySize();
              await tester.pumpWidget(baseWidget);
              await tester.pump();
              // assert
              expect(find.byType(BottomNavigationBar), findsNothing);
              final finder = find.byType(NavigationRail);
              expect(finder, findsOneWidget);
              final navRail = tester.widget<NavigationRail>(finder);
              expect(navRail.extended, equals(true));
            },
          );
          testWidgets(
            'should display navigation bar or rail with '
            '3 items (clothes, outfits, calendar)',
            (tester) async {
              tester.setLargeDisplaySize();
              await shouldDisplayThreeItems(tester);
            },
          );

          testWidgets(
            'should display ClothesPage on clothes item click',
            (tester) async {
              tester.setLargeDisplaySize();
              await shouldDisplayClothesPage(tester);
            },
          );
          testWidgets(
            'should display OutfitsPage on outfit item click',
            (tester) async {
              tester.setLargeDisplaySize();
              await shouldDisplayOutfitsPage(tester);
            },
          );
          testWidgets(
            'should display CalendarPage on calendar item click',
            (tester) async {
              tester.setLargeDisplaySize();
              await shouldDisplayCalendarPage(tester);
            },
          );
          testWidgets(
            'should change color of the last selected '
            'and currently selected item',
            (tester) async {
              tester.setLargeDisplaySize();
              await shouldChangeItemsColor(
                tester,
                unselectedColor: (theme) =>
                    theme.data.navigationRailTheme.unselectedIconTheme?.color ??
                    theme.data.colorScheme.onSurface,
                selectedColor: (theme) =>
                    theme.data.navigationRailTheme.selectedIconTheme?.color ??
                    theme.data.colorScheme.primary,
              );
            },
          );
        },
      );
    },
  );
}
