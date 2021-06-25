import 'package:clothes/features/clothes/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart' as s;

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'Shimmer',
    () {
      final widget = wrapWithApp(
        const Shimmer(
          child: Text('Shimmer effect'),
        ),
      );

      testWidgets(
        'should show child',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          expect(find.text('Shimmer effect'), findsOneWidget);
        },
      );
      testWidgets(
        'should wrap child with AbsorbPointer',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          expect(
            find.descendant(
              of: find.byType(Shimmer),
              matching: find.byType(AbsorbPointer),
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'should wrap child with Shimmer',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          expect(find.byType(s.Shimmer), findsOneWidget);
        },
      );
      testWidgets(
        'should shimmer base color equals canvas color',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));
          final finder = find.byType(s.Shimmer);
          final shimmer = tester.widget<s.Shimmer>(finder);
          expect(shimmer.gradient.colors.first, equals(theme.data.canvasColor));
        },
      );
      testWidgets(
        'should shimmer highlight color be darker when dark mode off',
        (tester) async {
          // arrange
          tester.binding.window.platformBrightnessTestValue = Brightness.light;
          await tester.pumpWidget(widget);
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));
          final canvasColor = HSLColor.fromColor(theme.data.canvasColor);
          final canvasLightness = canvasColor.lightness;

          final finder = find.byType(s.Shimmer);
          final shimmer = tester.widget<s.Shimmer>(finder);
          final shimmerHighlightColor =
              HSLColor.fromColor(shimmer.gradient.colors[2]);
          final shimmerLightness = shimmerHighlightColor.lightness;

          expect(shimmerLightness, lessThan(canvasLightness));
        },
      );
      testWidgets(
        'should shimmer highlight color be lighter when dark mode on',
        (tester) async {
          // arrange
          tester.binding.window.platformBrightnessTestValue = Brightness.dark;
          await tester.pumpWidget(widget);
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));
          final canvasColor = HSLColor.fromColor(theme.data.canvasColor);
          final canvasLightness = canvasColor.lightness;

          final finder = find.byType(s.Shimmer);
          final shimmer = tester.widget<s.Shimmer>(finder);
          final shimmerHighlightColor =
              HSLColor.fromColor(shimmer.gradient.colors[2]);
          final shimmerLightness = shimmerHighlightColor.lightness;

          expect(shimmerLightness, greaterThan(canvasLightness));
        },
      );
    },
  );
}
