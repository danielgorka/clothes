import 'package:clothes/app/app.dart';
import 'package:clothes/app/keys.dart';
import 'package:clothes/presentation/pages/calendar_page.dart';
import 'package:clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/presentation/pages/outfits_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/display_size.dart';

typedef ThemeColorGetter = Color? Function(Theme theme);

void main() {
  group(
    'NavigationScaffold',
    () {
      Future<void> shouldDisplayThreeItems(WidgetTester tester) async {
        // arrange
        await tester.pumpWidget(App());
        await tester.pump();
        // assert
        expect(find.byKey(Keys.clothesNavbarIcon), findsOneWidget);
        expect(find.byKey(Keys.outfitsNavbarIcon), findsOneWidget);
        expect(find.byKey(Keys.calendarNavbarIcon), findsOneWidget);
      }

      Future<void> shouldDisplayPage(
          WidgetTester tester, Type page, Key tapKey) async {
        // arrange
        await tester.pumpWidget(App());
        await tester.pump();
        // act
        await tester.tap(find.byKey(tapKey));
        await tester.pumpAndSettle();
        // assert
        expect(find.byType(page), findsOneWidget);
      }

      Future<void> shouldDisplayClothesPage(WidgetTester tester) async {
        shouldDisplayPage(tester, ClothesPage, Keys.clothesNavbarIcon);
      }

      Future<void> shouldDisplayOutfitsPage(WidgetTester tester) async {
        shouldDisplayPage(tester, OutfitsPage, Keys.outfitsNavbarIcon);
      }

      Future<void> shouldDisplayCalendarPage(WidgetTester tester) async {
        shouldDisplayPage(tester, CalendarPage, Keys.calendarNavbarIcon);
      }

      Future<void> shouldChangeItemsColor(
        WidgetTester tester, {
        required ThemeColorGetter unselectedColor,
        required ThemeColorGetter selectedColor,
      }) async {
        // arrange
        await tester.pumpWidget(App());
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
              await tester.pumpWidget(App());
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
              await tester.pumpWidget(App());
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
              await tester.pumpWidget(App());
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
