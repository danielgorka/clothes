import 'package:clothes/app/app.dart';
import 'package:clothes/app/theme.dart';
import 'package:clothes/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'App',
    () {
      testWidgets(
        'should show HomePage when app starts',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          expect(find.byType(HomePage), findsOneWidget);
        },
      );

      testWidgets(
        'should have MaterialApp.theme set to AppTheme.light theme',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          final finder = find.byType(MaterialApp);
          final materialApp = tester.widget<MaterialApp>(finder);
          expect(materialApp.theme, AppTheme.light);
        },
      );

      testWidgets(
        'should have MaterialApp.darkTheme set to AppTheme.dark theme',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          final finder = find.byType(MaterialApp);
          final materialApp = tester.widget<MaterialApp>(finder);
          expect(materialApp.darkTheme, AppTheme.dark);
        },
      );
    },
  );
}
