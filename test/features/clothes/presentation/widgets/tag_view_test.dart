import 'package:clothes/features/clothes/presentation/widgets/tag_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';
import '../../../../helpers/entities.dart';

void main() {
  group(
    'TagView',
    () {
      testWidgets(
        'should show Chip',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: TagView(
                  tag: clothTag1,
                ),
              ),
            ),
          );
          // assert
          expect(find.byType(Chip), findsOneWidget);
        },
      );
      testWidgets(
        'should show tag name',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: TagView(
                  tag: clothTag1,
                ),
              ),
            ),
          );
          // assert
          expect(find.text(clothTag1.name), findsOneWidget);
        },
      );
    },
  );
}
