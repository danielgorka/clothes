import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'ClothImageView',
    () {
      const image = ClothImage(
        id: 2,
        path: 'path/image.png',
      );

      testWidgets(
        'should have specified aspect ratio',
        (tester) async {
          // arrange
          await tester.pumpWidget(const ClothImageView(image: image));
          // assert
          final finder = find.byType(AspectRatio);
          final aspectRatio = tester.widget<AspectRatio>(finder);
          expect(aspectRatio.aspectRatio, equals(ClothesUtils.aspectRatio));
        },
      );

      testWidgets(
        'should have ClipRRect with border radius',
        (tester) async {
          // arrange
          await tester.pumpWidget(const ClothImageView(image: image));
          // assert
          final finder = find.byType(ClipRRect);
          final clipRRect = tester.widget<ClipRRect>(finder);
          expect(clipRRect.borderRadius, equals(ClothesUtils.borderRadius));
        },
      );

      testWidgets(
        'should show image from path',
        (tester) async {
          // arrange
          await tester.pumpWidget(const ClothImageView(image: image));
          // assert
          final finder = find.byType(ImageView);
          final imageView = tester.widget<ImageView>(finder);
          expect(imageView.path, equals(image.path));
        },
      );

      testWidgets(
        'should show NoImageView when image is null',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(
            const ClothImageView(image: null),
          ));
          // assert
          expect(find.byType(NoImageView), findsOneWidget);
        },
      );
    },
  );

  group(
    'NoImageView',
    () {
      testWidgets(
        'should show Container with card color',
        (tester) async {
          // arrange
          const color = Color(0xFF666666);
          await tester.pumpWidget(MaterialApp(
            theme: ThemeData(cardColor: color),
            home: const NoImageView(),
          ));
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));
          final finder = find.byType(Container);
          final container = tester.widget<Container>(finder);
          expect(container.color, theme.data.cardColor);
        },
      );
      testWidgets(
        'should show icon with disable color',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const NoImageView()));
          // assert
          final theme = tester.widget<Theme>(find.byType(Theme));
          final finder = find.byType(Icon);
          final icon = tester.widget<Icon>(finder);
          expect(icon.color, theme.data.disabledColor);
        },
      );
    },
  );
}
