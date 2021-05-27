import 'package:clothes/app/app.dart';
import 'package:clothes/app/keys.dart';
import 'package:clothes/presentation/pages/calendar_page.dart';
import 'package:clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/presentation/pages/outfits_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'BottomNavigationBar',
    () {
      testWidgets(
        'should display navigation bar with 3 items '
        '(clothes, outfits, calendar) on small screens',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          expect(find.byKey(Keys.clothesNavbarIcon), findsOneWidget);
          expect(find.byKey(Keys.outfitsNavbarIcon), findsOneWidget);
          expect(find.byKey(Keys.calendarNavbarIcon), findsOneWidget);
        },
      );
      testWidgets(
        'should navigation bar display ClothesPage on clothes item click',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // act
          await tester.tap(find.byKey(Keys.clothesNavbarIcon));
          await tester.pumpAndSettle();
          // assert
          expect(find.byType(ClothesPage), findsOneWidget);
        },
      );
      testWidgets(
        'should navigation bar display OutfitsPage on outfit item click',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // act
          await tester.tap(find.byKey(Keys.outfitsNavbarIcon));
          await tester.pumpAndSettle();
          // assert
          expect(find.byType(OutfitsPage), findsOneWidget);
        },
      );
      testWidgets(
        'should navigation bar display CalendarPage on calendar item click',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // act
          await tester.tap(find.byKey(Keys.calendarNavbarIcon));
          await tester.pumpAndSettle();
          // assert
          expect(find.byType(CalendarPage), findsOneWidget);
        },
      );
      testWidgets(
        'should navigation bar change color of '
        'the last selected and currently selected item',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // act
          await tester.tap(find.byKey(Keys.calendarNavbarIcon));
          await tester.pumpAndSettle();
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));

          final clothesIcon =
              tester.element(find.byKey(Keys.clothesNavbarIcon));
          final clothesIconTheme =
              clothesIcon.findAncestorWidgetOfExactType<IconTheme>()!;
          final unselectedColorValue = theme.data.unselectedWidgetColor.value;
          expect(
            clothesIconTheme.data.color?.value,
            equals(unselectedColorValue),
          );

          final calendarIcon =
              tester.element(find.byKey(Keys.calendarNavbarIcon));
          final calendarIconTheme =
              calendarIcon.findAncestorWidgetOfExactType<IconTheme>()!;
          final primaryColorValue = theme.data.primaryColor.value;
          expect(
            calendarIconTheme.data.color?.value,
            equals(primaryColorValue),
          );
        },
      );
    },
  );
}
