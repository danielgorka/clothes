import 'package:clothes/app/app.dart';
import 'package:clothes/app/pages/home_page.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

      testWidgets(
        'should render SystemUiOverlayRegion with child',
        (tester) async {
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          final finder = find.byType(SystemUiOverlayRegion);
          final systemUiOverlayRegion =
              tester.widget<SystemUiOverlayRegion>(finder);
          expect(systemUiOverlayRegion.child, isA<Router>());
        },
      );
    },
  );

  group(
    'SystemUiOverlayRegion',
    () {
      testWidgets(
        'should render AnnotatedRegion with AppTheme.overlayLight '
        'when dark mode off',
        (tester) async {
          tester.binding.window.platformBrightnessTestValue = Brightness.light;
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          final finder = find.byKey(Keys.systemUiOverlayAnnotatedRegion);
          final annotatedRegion = tester.widget<AnnotatedRegion>(finder);
          expect(annotatedRegion.value, AppTheme.overlayLight);
        },
      );

      testWidgets(
        'should render AnnotatedRegion with AppTheme.overlayDark '
        'when dark mode on',
        (tester) async {
          tester.binding.window.platformBrightnessTestValue = Brightness.dark;
          // arrange
          await tester.pumpWidget(App());
          await tester.pump();
          // assert
          final finder = find.byKey(Keys.systemUiOverlayAnnotatedRegion);
          final annotatedRegion = tester.widget<AnnotatedRegion>(finder);
          expect(annotatedRegion.value, AppTheme.overlayDark);
        },
      );
    },
  );
}
