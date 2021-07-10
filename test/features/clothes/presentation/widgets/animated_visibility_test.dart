import 'package:clothes/features/clothes/presentation/widgets/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'AnimatedVisibility',
    () {
      const duration = Duration(milliseconds: 200);
      testWidgets(
        'should show AnimatedCrossFade',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const AnimatedVisibility(
                visible: false,
                duration: duration,
                child: Text('Child'),
              ),
            ),
          );
          // assert
          expect(find.byType(AnimatedCrossFade), findsOneWidget);
        },
      );
      testWidgets(
        'should render child wrapped with enabled IgnorePointer '
        'when visibility is false',
        (tester) async {
          // arrange
          const child = Text('Child');
          await tester.pumpWidget(
            wrapWithApp(
              const AnimatedVisibility(
                visible: false,
                duration: duration,
                child: child,
              ),
            ),
          );
          // assert
          final finder = find.ancestor(
            of: find.byWidget(child),
            matching: find.byType(IgnorePointer),
          );
          final ignorePointer = tester.firstWidget<IgnorePointer>(finder);
          expect(ignorePointer.ignoring, isTrue);
        },
      );
      testWidgets(
        'should show child wrapped with disabled IgnorePointer '
        'when visibility is true',
        (tester) async {
          // arrange
          const child = Text('Child');
          await tester.pumpWidget(
            wrapWithApp(
              const AnimatedVisibility(
                visible: true,
                duration: duration,
                child: child,
              ),
            ),
          );
          // assert
          final finder = find.ancestor(
            of: find.byWidget(child),
            matching: find.byType(IgnorePointer),
          );
          final ignorePointer = tester.firstWidget<IgnorePointer>(finder);
          expect(ignorePointer.ignoring, isFalse);
        },
      );
    },
  );
}
