import 'package:clothes/features/clothes/presentation/widgets/multi_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'MultiFloatingActionButton',
    () {
      late int firstActionTaps;
      late int secondActionTaps;
      const openedChild = Text('Opened child');
      const closedChild = Text('Closed child');
      final firstAction = MultiFloatingActionButtonAction(
        onTap: () => firstActionTaps++,
        label: const Text('First'),
        child: const Text('1'),
      );
      final secondAction = MultiFloatingActionButtonAction(
        onTap: () => secondActionTaps++,
        label: const Text('Second'),
        child: const Text('2'),
      );
      final widget = wrapWithApp(
        Material(
          child: MultiFloatingActionButton(
            actions: [
              firstAction,
              secondAction,
            ],
            openedChild: openedChild,
            closedChild: closedChild,
          ),
        ),
      );

      setUp(() {
        firstActionTaps = 0;
        secondActionTaps = 0;
      });

      bool isWidgetVisible(WidgetTester tester, Finder finder) {
        final fadeFinder = find.ancestor(
          of: finder,
          matching: find.byType(FadeTransition),
        );
        final fadeTransition = tester.firstWidget(fadeFinder) as FadeTransition;
        return fadeTransition.opacity.value != 0.0;
      }

      bool isOpenedChildVisible(WidgetTester tester) {
        return isWidgetVisible(tester, find.byWidget(openedChild));
      }

      bool isClosedChildVisible(WidgetTester tester) {
        return isWidgetVisible(tester, find.byWidget(closedChild));
      }

      testWidgets(
        'should render FloatingActionButton with visible closedChild'
        ' and hidden openedChild',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          expect(isClosedChildVisible(tester), isTrue);
          expect(isOpenedChildVisible(tester), isFalse);
        },
      );
      testWidgets(
        'should show closedChild and openedChild after click during animation',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 1));
          // assert
          expect(isClosedChildVisible(tester), isTrue);
          expect(isOpenedChildVisible(tester), isTrue);
        },
      );
      testWidgets(
        'should render hidden closedChild and visible openedChild '
        'when animation ends after click',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pumpAndSettle();
          // assert
          expect(isClosedChildVisible(tester), isFalse);
          expect(isOpenedChildVisible(tester), isTrue);
        },
      );
      testWidgets(
        'should render visible closedChild and hidden openedChild '
        'when animation ends after second click',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pumpAndSettle();
          await tester.tap(find.byWidget(openedChild), warnIfMissed: false);
          await tester.pumpAndSettle();
          // assert
          expect(isClosedChildVisible(tester), isTrue);
          expect(isOpenedChildVisible(tester), isFalse);
        },
      );

      testWidgets(
        'should not show actions when widget is closed',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // assert
          expect(find.byWidget(firstAction.child), findsNothing);
          expect(find.byWidget(secondAction.child), findsNothing);
        },
      );
      testWidgets(
        'should show actions and labels when widget '
        'is opening during animation',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 1));
          // assert
          expect(find.byWidget(firstAction.child), findsOneWidget);
          expect(find.byWidget(firstAction.label!), findsOneWidget);
          expect(find.byWidget(secondAction.child), findsOneWidget);
          expect(find.byWidget(secondAction.label!), findsOneWidget);
        },
      );
      testWidgets(
        'should not show actions and labels when widget '
        'is closed after second click',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pumpAndSettle();
          await tester.tap(find.byWidget(openedChild), warnIfMissed: false);
          await tester.pumpAndSettle();
          // assert
          expect(find.byWidget(firstAction.child), findsNothing);
          expect(find.byWidget(firstAction.label!), findsNothing);
          expect(find.byWidget(secondAction.child), findsNothing);
          expect(find.byWidget(secondAction.label!), findsNothing);
        },
      );
      testWidgets(
        'should call onTap when tap action child',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pumpAndSettle();
          await tester.tap(find.byWidget(firstAction.child));
          await tester.pumpAndSettle();
          // assert
          expect(firstActionTaps, equals(1));
          expect(secondActionTaps, equals(0));
        },
      );
      testWidgets(
        'should call onTap when tap action label',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pumpAndSettle();
          await tester.tap(find.byWidget(secondAction.label!));
          await tester.pumpAndSettle();
          // assert
          expect(firstActionTaps, equals(0));
          expect(secondActionTaps, equals(1));
        },
      );

      testWidgets(
        'should do nothing when tap overlay when widget is closed',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          final offset = tester.getCenter(find.byKey(overlayKey));
          await tester.tapAt(offset);
          await tester.pump();
          await tester.pumpAndSettle();
          // assert
          expect(isClosedChildVisible(tester), isTrue);
          expect(isOpenedChildVisible(tester), isFalse);
        },
      );
      testWidgets(
        'should close widget when tap overlay when widget is opened',
        (tester) async {
          // arrange
          await tester.pumpWidget(widget);
          // act
          await tester.tap(find.byWidget(closedChild));
          await tester.pump();
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(overlayKey));
          await tester.pump();
          await tester.pumpAndSettle();
          // assert
          expect(isClosedChildVisible(tester), isTrue);
          expect(isOpenedChildVisible(tester), isFalse);
        },
      );
    },
  );
}
