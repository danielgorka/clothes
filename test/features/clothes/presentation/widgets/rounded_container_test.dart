import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/presentation/widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'RoundedContainerTest',
    () {
      testWidgets(
        'should show Container with null child',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            const RoundedContainer(),
          );
          // assert
          final finder = find.byType(Container);
          final container = tester.widget<Container>(finder);
          expect(container.child, isNull);
        },
      );
      testWidgets(
        'should show Container with specified width and height',
        (tester) async {
          // arrange
          const width = 32.0;
          const height = 123.0;
          await tester.pumpWidget(
            const RoundedContainer(
              width: width,
              height: height,
            ),
          );
          // assert
          final finder = find.byType(Container);
          final container = tester.widget<Container>(finder);
          expect(container.constraints!.maxWidth, width);
          expect(container.constraints!.maxHeight, height);
        },
      );
      testWidgets(
        'should show white rounded Container',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            const RoundedContainer(),
          );
          // assert
          final finder = find.byType(Container);
          final container = tester.widget<Container>(finder);
          final boxDecoration = container.decoration! as BoxDecoration;
          expect(boxDecoration.color, Colors.white);
          final borderRadius = boxDecoration.borderRadius! as BorderRadius;
          expect(borderRadius, equals(ClothesUtils.borderRadius));
        },
      );
    },
  );
}
