import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';
import '../../../../helpers/entities.dart';

void main() {
  group(
    'ClothItem',
    () {
      group(
        'Cloth image',
        () {
          testWidgets(
            'should show ClothImageView with first cloth image if exists',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(ClothItem(cloth: cloth1)));
              // assert
              final finder = find.byType(ClothImageView);
              final clothImageView = tester.widget<ClothImageView>(finder);
              expect(clothImageView.image, equals(clothImage1));
            },
          );
          testWidgets(
            'should show first ClothImageView with null image '
            'when cloth has no images',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: clothWithoutImages),
              ));
              // assert
              final finder = find.byType(ClothImageView);
              final clothImageView = tester.widget<ClothImageView>(finder);
              expect(clothImageView.image, isNull);
            },
          );
        },
      );

      group(
        'Gradient',
        () {
          testWidgets(
            'should not show BottomGradient when cloth has empty name',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: clothWithoutName),
              ));
              // assert
              expect(find.byType(BottomGradient), findsNothing);
            },
          );
          testWidgets(
            'should show BottomGradient when cloth has name',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: cloth1),
              ));
              // assert
              expect(find.byType(BottomGradient), findsOneWidget);
            },
          );
        },
      );

      group(
        'Cloth name',
        () {
          testWidgets(
            'should not show Text with name when cloth has empty name',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: clothWithoutName),
              ));
              // assert
              expect(find.byType(Text), findsNothing);
            },
          );
          testWidgets(
            'should show Text with name when cloth has name',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: cloth1),
              ));
              // assert
              expect(find.text(cloth1.name), findsOneWidget);
            },
          );
        },
      );

      group(
        'InkWell',
        () {
          testWidgets(
            'should render InkWell with rounded corners',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(
                ClothItem(cloth: cloth1),
              ));
              // assert
              final finder = find.byType(InkWell);
              final inkWell = tester.widget<InkWell>(finder);
              expect(
                inkWell.borderRadius,
                equals(ClothesUtils.borderRadius),
              );
            },
          );
          testWidgets(
            'should call onTap after tapping widget',
            (tester) async {
              // arrange
              bool tapped = false;
              await tester.pumpWidget(wrapWithApp(
                ClothItem(
                  cloth: cloth1,
                  onTap: () => tapped = true,
                ),
              ));
              // act
              await tester.tap(find.byType(ClothItem));
              // assert
              expect(tapped, isTrue);
            },
          );
        },
      );
    },
  );

  group(
    'BottomGradient',
    () {
      testWidgets(
        'should show DecoratedBox with LinearGradient',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(
            Stack(
              children: const [BottomGradient()],
            ),
          ));
          // assert
          final finder = find.byType(DecoratedBox);
          final decoratedBox = tester.widget<DecoratedBox>(finder);
          final decoration = decoratedBox.decoration as BoxDecoration;
          expect(decoration.gradient, isA<LinearGradient>());
        },
      );
    },
  );
}
