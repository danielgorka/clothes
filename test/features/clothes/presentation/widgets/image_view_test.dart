import 'package:cached_network_image/cached_network_image.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ImageView',
    () {
      const fit = BoxFit.cover;

      testWidgets(
        'should show CachedNetworkImage when path is http url',
        (tester) async {
          // arrange
          const path = 'http://test.pl';
          await tester.pumpWidget(const ImageView(path: path));
          // assert
          final finder = find.byType(CachedNetworkImage);
          final cachedNetworkImage = tester.widget<CachedNetworkImage>(finder);
          expect(cachedNetworkImage.imageUrl, equals(path));
          expect(cachedNetworkImage.fit, equals(fit));
        },
      );
      testWidgets(
        'should show CachedNetworkImage when path is https url',
        (tester) async {
          // arrange
          const path = 'https://test.pl';
          await tester.pumpWidget(const ImageView(path: path));
          // assert
          final finder = find.byType(CachedNetworkImage);
          final cachedNetworkImage = tester.widget<CachedNetworkImage>(finder);
          expect(cachedNetworkImage.imageUrl, equals(path));
          expect(cachedNetworkImage.fit, equals(fit));
        },
      );
      testWidgets(
        'should show CachedNetworkImage when path is base64 url',
        (tester) async {
          // arrange
          const path = 'data:image/png;base64,'
              'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAAC'
              'NbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0D'
              'HxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';
          await tester.pumpWidget(const ImageView(path: path));
          // assert
          final finder = find.byType(CachedNetworkImage);
          final cachedNetworkImage = tester.widget<CachedNetworkImage>(finder);
          expect(cachedNetworkImage.imageUrl, equals(path));
          expect(cachedNetworkImage.fit, equals(fit));
        },
      );
      testWidgets(
        'should show Image.file when path is not url',
        (tester) async {
          // arrange
          const path = 'images/image.png';
          await tester.pumpWidget(const ImageView(path: path));
          // assert
          final finder = find.byType(Image);
          final imageWidget = tester.widget<Image>(finder);
          final fileImage = imageWidget.image as FileImage;
          expect(fileImage.file.path, equals(path));
          expect(imageWidget.fit, equals(fit));
        },
      );
    },
  );
}
