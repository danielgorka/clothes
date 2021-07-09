import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'AppShimmer',
    () {
      Widget getWidget([ShimmerType type = ShimmerType.normal]) {
        return wrapWithApp(
          AppShimmer(
            type: type,
            child: const Text('Shimmer effect'),
          ),
        );
      }

      Future<void> testHighlightColor({
        required WidgetTester tester,
        required Widget widget,
        required bool lighter,
      }) async {
        // arrange
        await tester.pumpWidget(widget);
        // assert
        final theme = tester.widget<Theme>(find.byType(Theme));
        final canvasColor = HSLColor.fromColor(theme.data.canvasColor);
        final canvasLightness = canvasColor.lightness;

        final finder = find.byType(Shimmer);
        final shimmer = tester.widget<Shimmer>(finder);
        final shimmerHighlightColor =
            HSLColor.fromColor(shimmer.gradient.colors[2]);
        final shimmerLightness = shimmerHighlightColor.lightness;

        if (lighter) {
          expect(shimmerLightness, greaterThan(canvasLightness));
        } else {
          expect(shimmerLightness, lessThan(canvasLightness));
        }
      }

      testWidgets(
        'should show child',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget());
          // assert
          expect(find.text('Shimmer effect'), findsOneWidget);
        },
      );
      testWidgets(
        'should wrap child with AbsorbPointer',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget());
          // assert
          expect(
            find.descendant(
              of: find.byType(AppShimmer),
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
          await tester.pumpWidget(getWidget());
          // assert
          expect(find.byType(Shimmer), findsOneWidget);
        },
      );

      group(
        'Type normal',
        () {
          testWidgets(
            'should shimmer highlight color be darker when dark mode off',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.light;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(),
                lighter: false,
              );
            },
          );
          testWidgets(
            'should shimmer highlight color be lighter when dark mode on',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.dark;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(),
                lighter: true,
              );
            },
          );
        },
      );

      group(
        'Type canvas',
        () {
          testWidgets(
            'should shimmer base color equals canvas color',
            (tester) async {
              // arrange
              await tester.pumpWidget(getWidget(ShimmerType.canvas));
              // assert
              final theme = tester.widget<Theme>(find.byType(Theme));
              final finder = find.byType(Shimmer);
              final shimmer = tester.widget<Shimmer>(finder);
              expect(
                shimmer.gradient.colors.first,
                equals(theme.data.canvasColor),
              );
            },
          );
          testWidgets(
            'should shimmer highlight color be darker when dark mode off',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.light;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(ShimmerType.canvas),
                lighter: false,
              );
            },
          );
          testWidgets(
            'should shimmer highlight color be lighter when dark mode on',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.dark;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(ShimmerType.canvas),
                lighter: true,
              );
            },
          );
        },
      );

      group(
        'Type text',
        () {
          testWidgets(
            'should shimmer highlight color be darker when dark mode off',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.light;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(ShimmerType.text),
                lighter: false,
              );
            },
          );
          testWidgets(
            'should shimmer highlight color be lighter when dark mode on',
            (tester) async {
              tester.binding.window.platformBrightnessTestValue =
                  Brightness.dark;
              await testHighlightColor(
                tester: tester,
                widget: getWidget(ShimmerType.text),
                lighter: true,
              );
            },
          );
        },
      );
    },
  );
}
