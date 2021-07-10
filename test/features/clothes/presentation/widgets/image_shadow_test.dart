import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/app/utils/theme.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'ImageShadow',
    () {
      Widget getWidget(
        ShadowSide side, {
        bool overrideSystemUiOverlayStyle = false,
      }) {
        return wrapWithApp(
          Stack(
            children: [
              ImageShadow(
                side: side,
                overrideSystemUiOverlayStyle: overrideSystemUiOverlayStyle,
              ),
            ],
          ),
        );
      }

      testWidgets(
        'should show Positioned',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget(ShadowSide.bottom));
          // assert
          expect(find.byType(Positioned), findsOneWidget);
        },
      );
      testWidgets(
        'should wrap with IgnorePointer',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget(ShadowSide.bottom));
          // assert
          expect(
            find.descendant(
              of: find.byType(ImageShadow),
              matching: find.byType(IgnorePointer),
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'should not show AnnotatedRegion '
        'when overrideSystemUiOverlayStyle is false',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            getWidget(ShadowSide.bottom),
          );
          // assert
          expect(find.byKey(Keys.imageShadowAnnotatedRegion), findsNothing);
        },
      );
      testWidgets(
        'should show AnnotatedRegion with AppTheme.overlayDark '
        'when overrideSystemUiOverlayStyle is true',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            getWidget(
              ShadowSide.bottom,
              overrideSystemUiOverlayStyle: true,
            ),
          );
          // assert
          final finder = find.byKey(Keys.imageShadowAnnotatedRegion);
          final annotatedRegion = tester.widget<AnnotatedRegion>(finder);
          expect(annotatedRegion.value, equals(AppTheme.overlayDark));
        },
      );
      testWidgets(
        'should show LinearGradient from bottom to top when shadow side is top',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget(ShadowSide.top));
          // assert
          final finder = find.byType(DecoratedBox);
          final decoratedBox = tester.widget<DecoratedBox>(finder);
          final boxDecoration = decoratedBox.decoration as BoxDecoration;
          final linearGradient = boxDecoration.gradient! as LinearGradient;
          expect(linearGradient.begin, equals(Alignment.bottomCenter));
          expect(linearGradient.end, equals(Alignment.topCenter));
        },
      );
      testWidgets(
        'should show LinearGradient from top to bottom '
        'when shadow side is bottom',
        (tester) async {
          // arrange
          await tester.pumpWidget(getWidget(ShadowSide.bottom));
          // assert
          final finder = find.byType(DecoratedBox);
          final decoratedBox = tester.widget<DecoratedBox>(finder);
          final boxDecoration = decoratedBox.decoration as BoxDecoration;
          final linearGradient = boxDecoration.gradient! as LinearGradient;
          expect(linearGradient.begin, equals(Alignment.topCenter));
          expect(linearGradient.end, equals(Alignment.bottomCenter));
        },
      );
    },
  );
}
