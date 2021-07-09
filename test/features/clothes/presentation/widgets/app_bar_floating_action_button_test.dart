import 'package:clothes/features/clothes/presentation/widgets/app_bar_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'AppBarFloatingActionButton',
    () {
      Widget _wrapWithScrollable({
        required ScrollController controller,
        required Widget widget,
      }) {
        return wrapWithApp(
          Stack(
            children: [
              ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return Text(index.toString());
                },
              ),
              widget,
            ],
          ),
        );
      }

      testWidgets(
        'should show child',
        (tester) async {
          // arrange
          final controller = ScrollController();
          const child = Icon(Icons.add);
          await tester.pumpWidget(
            _wrapWithScrollable(
              controller: controller,
              widget: AppBarFloatingActionButton(
                scrollController: controller,
                appBarHeight: 100.0,
                onPressed: () {},
                child: child,
              ),
            ),
          );
          // assert
          expect(find.byWidget(child), findsOneWidget);
        },
      );

      testWidgets(
        'should wrap with Positioned where top equals to app bar height '
        'subtract half of the floating action button height',
        (tester) async {
          // arrange
          final controller = ScrollController();
          const appBarHeight = 100.0;
          await tester.pumpWidget(
            _wrapWithScrollable(
              controller: controller,
              widget: AppBarFloatingActionButton(
                scrollController: controller,
                appBarHeight: appBarHeight,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          );
          // assert
          final finder = find.byType(Positioned);
          final positioned = tester.widget<Positioned>(finder);
          final widgetSize = tester.getSize(find.byType(FloatingActionButton));
          expect(positioned.top, equals(appBarHeight - widgetSize.height / 2));
        },
      );

      testWidgets(
        'should move floating action button when scrollable is scrolled',
        (tester) async {
          // arrange
          const scrollSize = 50.0;
          final controller = ScrollController();
          const appBarHeight = 100.0;
          await tester.pumpWidget(
            _wrapWithScrollable(
              controller: controller,
              widget: AppBarFloatingActionButton(
                scrollController: controller,
                appBarHeight: appBarHeight,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          );
          // act
          await tester.drag(
            find.byType(ListView),
            const Offset(0.0, -scrollSize),
          );
          await tester.pump();
          // assert
          final finder = find.byType(Positioned);
          final positioned = tester.widget<Positioned>(finder);
          final widgetSize = tester.getSize(find.byType(FloatingActionButton));
          expect(
            positioned.top,
            equals(appBarHeight - widgetSize.height / 2 - scrollSize),
          );
        },
      );

      testWidgets(
        'should call onPressed when floating action button is pressed',
        (tester) async {
          // arrange
          int callCount = 0;
          final controller = ScrollController();
          await tester.pumpWidget(
            _wrapWithScrollable(
              controller: controller,
              widget: AppBarFloatingActionButton(
                scrollController: controller,
                appBarHeight: 100.0,
                onPressed: () {
                  callCount++;
                },
                child: const Icon(Icons.add),
              ),
            ),
          );
          // act
          await tester.tap(find.byType(FloatingActionButton));
          // assert
          expect(callCount, equals(1));
        },
      );
    },
  );
}
